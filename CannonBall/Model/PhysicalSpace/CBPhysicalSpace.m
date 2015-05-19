//
//  CBPhysicalSpace.m
//  CannonBall
//
//  Created by Sergei Smagleev on 18/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import "CBPhysicalSpace.h"
#import "chipmunk.h"


#define BOUNDING_CIRCLE     (1)
#define BORDER_TYPE         (2)
#define MAX_ENTITIES        (20)

@interface CBPhysicalSpace () {
    cpSpace *mPhysicsSpace;
    NSMutableArray *mEntities;
}
@property (nonatomic, weak) CBCannonBall *movingCannonBall;
@end

@implementation CBPhysicalSpace

@synthesize entities = mEntities;

- (instancetype)init {
    self = [super init];
    if (self) {
        mPhysicsSpace = cpSpaceNew();
        mPhysicsSpace->gravity = cpv(0, 300);
        mEntities = [[NSMutableArray alloc] init];
        self.movingCannonBall = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public methods
- (void)setBoundaries:(CGRect)boundaries {
    cpBB bounds = cpBBNew(0, boundaries.size.height, boundaries.size.width, 0);
    [self addBounds:bounds thickness:1.0f elasticity:1.0f friction:1.0f
      collisionType:BORDER_TYPE toSpace:mPhysicsSpace];
    cpSpaceAddCollisionHandler(mPhysicsSpace, BOUNDING_CIRCLE, BORDER_TYPE,
                               NULL, NULL, NULL, NULL, NULL);
    cpSpaceAddCollisionHandler(mPhysicsSpace, BOUNDING_CIRCLE, BOUNDING_CIRCLE,
                               NULL, NULL, NULL, NULL, NULL);
}

- (void)updateWithTimeInterval:(cpFloat)time {
    cpSpaceStep(mPhysicsSpace, time);
    [self.movingCannonBall updatePosition];
}

- (CBCannonBall *)addNewCannonBallWithRadius:(CGFloat)radius
                              velocityVector:(CGPoint)vector {
    if (self.entities.count >= MAX_ENTITIES)
        return nil;
    CBCannonBall *cannonBall = [[CBCannonBall alloc] initWithPhysicanBounds:CGRectMake(0, 0, radius * 2.0f, radius * 2.0f)];
    cannonBall.body->v = vector;
    cpSpaceAddBody(mPhysicsSpace, cannonBall.body);
    cpSpaceAddShape(mPhysicsSpace, cannonBall.shape);
    [self.entities addObject:cannonBall];
    return cannonBall;
}

- (void)startMovingCannonBallAtIndex:(NSUInteger)index {
    self.movingCannonBall = [mEntities objectAtIndex:index];
    [self.movingCannonBall startMoving];
}

- (void)moveCannonBallToPosition:(CGPoint)location {
    self.movingCannonBall.desiredLocation = location;
}

- (void)endMovingCannonBall {
    [self.movingCannonBall endMoving];
    self.movingCannonBall = nil;
}

#pragma mark - Private methods

- (void)addBounds:(cpBB)bounds
        thickness:(cpFloat)radius
       elasticity:(cpFloat)elasticity
         friction:(cpFloat)friction
    collisionType:(cpCollisionType)collisionType
          toSpace:(cpSpace *)sp {
    
    cpFloat l = bounds.l - radius;
    cpFloat b = bounds.b + radius;
    cpFloat r = bounds.r + radius;
    cpFloat t = bounds.t - radius;
    
    cpBody *body = cpBodyNewStatic();
    cpShape *shape = NULL;
    
    shape       = cpSegmentShapeNew(body, cpv(l,b), cpv(l,t), radius);
    shape->u    = friction;
    shape->e    = elasticity;
    shape->collision_type = collisionType;
    cpSpaceAddStaticShape(sp, shape);
    
    shape       = cpSegmentShapeNew(body, cpv(l,t), cpv(r,t), radius);
    shape->u    = friction;
    shape->e    = elasticity;
    shape->collision_type = collisionType;
    cpSpaceAddStaticShape(sp, shape);
    
    shape       = cpSegmentShapeNew(body, cpv(r,t), cpv(r,b), radius);
    shape->u    = friction;
    shape->e    = elasticity;
    shape->collision_type = collisionType;
    cpSpaceAddStaticShape(sp, shape);
    
    shape       = cpSegmentShapeNew(body, cpv(r,b), cpv(l,b), radius);
    shape->u    = friction;
    shape->e    = elasticity;
    shape->collision_type = collisionType;
    cpSpaceAddStaticShape(sp, shape);
}

- (void)orientationChanged:(NSNotification *)notification{
    NSLog(@"orientation changed");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            cpSpaceSetGravity(mPhysicsSpace, cpv(0, 300));
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            cpSpaceSetGravity(mPhysicsSpace, cpv(0, -300));
            break;
        case UIDeviceOrientationLandscapeLeft:
            cpSpaceSetGravity(mPhysicsSpace, cpv(-300, 0));
            break;
        case UIDeviceOrientationLandscapeRight:
            cpSpaceSetGravity(mPhysicsSpace, cpv(300, 0));
            break;
        default:
            break;
    }
}

@end

//
//  CBCannonBall.m
//  CannonBall
//
//  Created by Sergei Smagleev on 16/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import "CBCannonBall.h"

#define DELTA 0.001f

@interface CBCannonBall() {
@private
    BOOL moveTo;
    BOOL stopped;
    CGPoint staticLocation;
    cpVect  mDesiredLocation;
    UIPanGestureRecognizer *mPanGesture;
    UILongPressGestureRecognizer *mLongPressure;
    cpBody  *mBody;
    cpShape *mShape;
    cpFloat mMoment;
}
@end

@implementation CBCannonBall

@synthesize shape = mShape, body = mBody, desiredLocation = mDesiredLocation;

- (instancetype)initWithPhysicanBounds:(CGRect)physFrame {
    self = [super init];
    if (self) {
        mMoment = cpMomentForCircle(5.0f, physFrame.size.width/2, physFrame.size.width/2, CGPointZero);
        mBody = cpBodyNew(5.0f, mMoment);
        
        mShape = cpCircleShapeNew(mBody, physFrame.size.width/2, CGPointZero);
        mShape->e = 0.5;
        mShape->u = 0.5;
        mShape->collision_type = (1);
    }
    return self;
}

- (void)moveTo:(CGPoint)location {
    mBody->p = cpv(location.x, location.y);
}

- (void)updatePosition {
    CGFloat length = cpvlength(cpvsub(mDesiredLocation, mBody->p));
    if (length > DELTA) {
        mBody->v = cpvclamp(cpvmult(cpvsub(mDesiredLocation, mBody->p), 1.0f/0.016666f), length * 10);
    } else {
        mDesiredLocation = mBody->p;
        mBody->v = cpv(0, 0);
    }
}

- (void)startMoving {
    moveTo = YES;
    mDesiredLocation = mBody->p;
}

- (void)endMoving {
    moveTo = NO;
}

@end

//
//  CBCannonBallController.m
//  CannonBall
//
//  Created by Sergei Smagleev on 16/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import "CBCannonBallController.h"
#import <QuartzCore/QuartzCore.h>
#import "chipmunk.h"
#import "CBCannonBallView.h"
#import "CBCannonBall.h"
#import "CBOverlayView.h"
#import "CBPhysicalSpace.h"

#define CANNONBALL_RADIUS (25.0f)

@interface CBCannonBallController () <CBOverlayViewDelegate, CBCannonBallViewDelegate> {
    CADisplayLink   *mDisplayLink;
    NSMutableArray  *mCannonBallViews;
    CBOverlayView   *mOverlayView;
    CBPhysicalSpace *mSpace;
//    CBCannonBall    *movingCannonBall;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectionControl;

@end

@implementation CBCannonBallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init cannonballview storage
    mCannonBallViews = [[NSMutableArray alloc] init];
    
    //put overlay view
    mOverlayView = [[CBOverlayView alloc] initWithFrame:self.view.bounds];
    mOverlayView.delegate = self;
    [self.view insertSubview:mOverlayView belowSubview:self.selectionControl];
    
    //setup the segmented control
    [self.selectionControl addTarget:self action:@selector(selectionChanged:) forControlEvents:UIControlEventValueChanged];
    
    //init physical space
    mSpace = [[CBPhysicalSpace alloc] init];
    [mSpace setBoundaries:[UIScreen mainScreen].bounds];
    [self startMainLoop];
}

- (void)selectionChanged:(UISegmentedControl *)control {
    switch (control.selectedSegmentIndex) {
        case 0:
            mOverlayView.userInteractionEnabled = YES;
            break;
        case 1:
            mOverlayView.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

#pragma mark - Physics

- (void)startMainLoop {
    mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    mDisplayLink.frameInterval = 1;
    [mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)update {
    cpFloat dt = mDisplayLink.duration * mDisplayLink.frameInterval;
    [mSpace updateWithTimeInterval:dt];
    [self updateCannonBallViews];
}

- (void)updateCannonBallViews {
    [mCannonBallViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CBCannonBall *cannonBall = (CBCannonBall *)[mSpace.entities objectAtIndex:idx];
        CGPoint location = cannonBall.body->p;
        view.center = location;
        view.transform = CGAffineTransformMakeRotation(cannonBall.body->a);
    }];
}

#pragma mark - CBOverlayViewDelegate methods

- (void)overlayViewTouchesEnded:(CBOverlayView *)overlayView withVector:(CGPoint)vector {
    cpVect vect = cpvmult(cpv(vector.x, -vector.y), 5.0f);
    CBCannonBall *cannonBall = [mSpace addNewCannonBallWithRadius:CANNONBALL_RADIUS velocityVector:vect];
    [cannonBall moveTo:CGPointMake(cannonBall.radius, self.view.frame.size.height - cannonBall.radius)];
    
    if (cannonBall != nil) {
        CGRect cannonBallRect = CGRectMake(.0f, .0f, CANNONBALL_RADIUS * 2, CANNONBALL_RADIUS * 2);
        CBCannonBallView *cannonBallView = [[CBCannonBallView alloc] initWithFrame:cannonBallRect];
        cannonBallView.backgroundColor = [UIColor redColor];
        cannonBallView.center = cannonBall.body->p;
        cannonBallView.delegate = self;
        [mCannonBallViews addObject:cannonBallView];
        [self.view insertSubview:cannonBallView belowSubview:overlayView];
    }
}

#pragma mark - CBCannonBallViewDelegate methods

- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureBegan:(CGPoint)location {
    NSUInteger idx = [mCannonBallViews indexOfObject:cannonBallView];
    [mSpace startMovingCannonBallAtIndex:idx];
}

- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureChanged:(CGPoint)location {
    [mSpace moveCannonBallToPosition:location];
}

- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureEnded:(CGPoint)location {
    [mSpace endMovingCannonBall];
}

@end

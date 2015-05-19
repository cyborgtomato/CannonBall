//
//  CBCannonBallView.m
//  CannonBall
//
//  Created by Sergei Smagleev on 16/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import "CBCannonBallView.h"

@interface CBCannonBallView () {
    UILabel *mNumberLabel;
}

@end

@implementation CBCannonBallView

- (instancetype)initWithFrame:(CGRect)frame {
    static int entitiesCount = 0;
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.height/2.0f;
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
        entitiesCount++;
        mNumberLabel = [[UILabel alloc] initWithFrame:self.bounds];
        mNumberLabel.textColor = [UIColor whiteColor];
        mNumberLabel.textAlignment = NSTextAlignmentCenter;
        mNumberLabel.text = [NSString stringWithFormat:@"%d", entitiesCount];
        mNumberLabel.font = [UIFont fontWithName:@"HelvetivaNeue-Light" size:20.0f];
        [self addSubview:mNumberLabel];
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate cannonBallView:self gestureBegan:[recognizer locationInView:[self superview]]];
            break;
        case UIGestureRecognizerStateChanged:
            [self.delegate cannonBallView:self gestureChanged:[recognizer locationInView:[self superview]]];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self.delegate cannonBallView:self gestureEnded:[recognizer locationInView:[self superview]]];
            break;
        default:
            break;
    }
}

@end

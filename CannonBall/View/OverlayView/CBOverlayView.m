//
//  CBOverlayView.m
//  CannonBall
//
//  Created by Sergei Smagleev on 18/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import "CBOverlayView.h"

@interface CBOverlayView () {
    UIImageView *mImageLayer;
}

@end

@implementation CBOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mImageLayer = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:mImageLayer];
    }
    return self;
}

#pragma mark - Drawing methods

- (void)drawLineToPoint:(CGPoint)point {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0f);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor greenColor].CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, self.frame.size.height);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    mImageLayer.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)clearView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGFloat white[]={1., 1.};
    CGContextSetFillColor(UIGraphicsGetCurrentContext(), white);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeDestinationOut);
    CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    mImageLayer.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Handling touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location;
    for (UITouch *touch in touches) {
        location = [touch locationInView:self];
    }
    [self drawLineToPoint:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location;
    for (UITouch *touch in touches) {
        location = [touch locationInView:self];
    }
    [self drawLineToPoint:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self clearView];
    CGPoint location;
    for (UITouch *touch in touches) {
        location = [touch locationInView:self];
    }
    if (self.delegate != nil) {
        [self.delegate overlayViewTouchesEnded:self withVector:CGPointMake(location.x, self.frame.size.height - location.y)];
        NSLog(@"location: %f %f", location.x, self.frame.size.height - location.y);
    }
}

@end

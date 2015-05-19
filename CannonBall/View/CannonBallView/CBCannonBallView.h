//
//  CBCannonBallView.h
//  CannonBall
//
//  Created by Sergei Smagleev on 16/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBCannonBallView;

@protocol CBCannonBallViewDelegate <NSObject>

- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureBegan:(CGPoint)location;
- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureChanged:(CGPoint)location;
- (void)cannonBallView:(CBCannonBallView *)cannonBallView gestureEnded:(CGPoint)location;

@end

@interface CBCannonBallView : UIView

@property (nonatomic, assign) id<CBCannonBallViewDelegate>  delegate;

@end

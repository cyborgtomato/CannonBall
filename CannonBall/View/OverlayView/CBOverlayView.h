//
//  CBOverlayView.h
//  CannonBall
//
//  Created by Sergei Smagleev on 18/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBOverlayView;

@protocol CBOverlayViewDelegate <NSObject>

- (void)overlayViewTouchesEnded:(CBOverlayView *)overlayView withVector:(CGPoint)vector;

@end

@interface CBOverlayView : UIView

@property (nonatomic, assign) id<CBOverlayViewDelegate> delegate;

@end

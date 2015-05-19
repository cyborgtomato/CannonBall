//
//  CBCannonBall.h
//  CannonBall
//
//  Created by Sergei Smagleev on 16/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "chipmunk.h"

@interface CBCannonBall : NSObject

@property (nonatomic, assign) CGPoint desiredLocation;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign, readonly) cpBody  *body;
@property (nonatomic, assign, readonly) cpShape *shape;

- (instancetype)initWithPhysicanBounds:(CGRect)physFrame;
- (void)moveTo:(CGPoint)location;
- (void)updatePosition;

- (void)startMoving;
- (void)endMoving;

@end

//
//  CBPhysicalSpace.h
//  CannonBall
//
//  Created by Sergei Smagleev on 18/05/15.
//  Copyright (c) 2015 Sergei Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBCannonBall.h"
#import <UIKit/UIKit.h>

@interface CBPhysicalSpace : NSObject

//+ (CBPhysicalSpace *)shared;
- (void)setBoundaries:(CGRect)boundaries;
- (CBCannonBall *)addNewCannonBallWithRadius:(CGFloat)radius
                              velocityVector:(CGPoint)vector;
- (void)startMovingCannonBallAtIndex:(NSUInteger)index;
- (void)moveCannonBallToPosition:(CGPoint)location;
- (void)endMovingCannonBall;
- (void)updateWithTimeInterval:(cpFloat)time;

@property (nonatomic, strong, readonly) NSMutableArray *entities;

@end

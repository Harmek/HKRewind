//
//  HKRewindGestureRecognizer.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKRewindGestureRecognizer : UIGestureRecognizer

/**
 * The number of fingers that must be touching the view for this gesture to be recognized.
 */
@property (nonatomic, assign) NSUInteger numberOfTouchesRequired;

/**
 * The number of seconds the user is allowed to be inactive before the recognizer is cancelled.
 */
@property (nonatomic, assign) NSTimeInterval timeout;

@property (nonatomic, assign) CGFloat minimumRadius;

@property (nonatomic, assign) CGFloat maximumRadius;

@property (nonatomic, readonly) CGFloat radius;

/**
 * Boolean value determining whether the user is performing a clockwise rotation or not
 */
@property (nonatomic, readonly) BOOL clockwise;

/**
 * Angle where the user's last touch point is. The rotation value is a single value that varies over time. It is not the delta value from the last time that the rotation was reported. To get the delta, use the rotationDelta property.
 */
@property (nonatomic, readonly) CGFloat rotation;

/**
 * Delta value from the last rotation value. This value is already signed, do not use the clockwise property to negate this value.
 */
@property (nonatomic, readonly) CGFloat rotationDelta;

/**
 * The velocity of the rotation gesture in radians per second.
 */
@property (nonatomic, readonly) CGFloat velocity;

/**
 * Approximate center of the circle formed by the user's touches in view's coordinates.
 */
@property (nonatomic, readonly) CGPoint center;

@end

//
//  HKRewindGestureRecognizer.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * HKRewindGestureRecognizer is a concrete subclass of UIGestureRecognizer that looks for rotation gestures, more specifically when the user moves the fingers to draw a circle (like on a vinyl disk).
 * Rewind is a continuous gesture. It begins when the touches have moved enough to be considered a circular motion. The gesture changes when the finger moves. It ends when the fingers have lifted. At each stage in the gesture, the gesture recognizer sends its action message.
 */
@interface HKRewindGestureRecognizer : UIGestureRecognizer

/**
 * The number of fingers that must be touching the view for this gesture to be recognized.
 */
@property (nonatomic, assign) NSUInteger numberOfTouchesRequired;

/**
 * The number of seconds the user is allowed to be inactive before the recognizer is cancelled.
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 * The approximate radius of the circle that the user is likely to draw. If a visual cue is shown (like a circle) when the user performs the gesture, it should be set to the visual cue's radius.
 */
@property (nonatomic, assign) CGFloat maximumRadius;

/**
 * The maximum absolute value that rotationDelta will be assigned, in radians. Default value is Pi/50.
 */
@property (nonatomic, assign) CGFloat maximumRotationDelta;
/**
 * Boolean value determining whether the user is performing a clockwise rotation or not.
 */
@property (nonatomic, readonly) BOOL clockwise;

/**
 * Delta value from the last rotation value. This is a signed value, do not use the clockwise property to negate this value.
 */
@property (nonatomic, readonly) CGFloat rotationDelta;

/**
 * The velocity of the rotation gesture in radians per second.
 */
@property (nonatomic, readonly) CGFloat velocity;

@end

//
//  HKRewindGestureRecognizer.h
//  HKRewind
//
//  Copyright (c) 2013, Panos Baroudjian.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.


#import <UIKit/UIKit.h>

/** HKRewindGestureRecognizer is a concrete subclass of UIGestureRecognizer that looks for rotation gestures, more specifically when the user moves the fingers to draw a circle (like when turning a vinyl disk).

Rewind is a continuous gesture. It begins when the touches have moved enough to be considered a circular motion. The gesture changes when the finger moves. It ends when the fingers have lifted. At each stage in the gesture, the gesture recognizer sends its action message.
 */
@interface HKRewindGestureRecognizer : UIGestureRecognizer

/**---------------------------------------------------------------------------------------
 * @name Configuring the Recognizer
 *  ---------------------------------------------------------------------------------------
 */
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

/**---------------------------------------------------------------------------------------
 * @name Interpreting the Gesture
 *  ---------------------------------------------------------------------------------------
 */
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

//
//  HKRewindHUDView.h
//  HKRewind
//
//  Copyright (c) 2012-2013, Panos Baroudjian.
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
#import <HKCircularProgressView.h>

/**
 * HKRewindHUDView is a simple view that encapsulates a HKCircularProgressView and two labels. It is supposed to be used as a visual representation of the HKRewindGestureRecognizer progression. 
 */
@interface HKRewindHUDView : UIView

/**---------------------------------------------------------------------------------------
 * @name Accessing the HUD's Views
 *  ---------------------------------------------------------------------------------------
 */
/** Returns the HKCircularProgressView used to display the progression (read-only).
 */
@property (nonatomic, readonly) HKCircularProgressView *circularProgressView;

/** The view that is displayed behind the HUD's other content.
 */
@property (nonatomic, strong) UIView *backgroundView;

/** The main view to which you can add custom content. (read-only)
 */
@property (nonatomic, readonly) UIView *contentView;


/**---------------------------------------------------------------------------------------
 * @name Accessing the HUD's labels
 *  ---------------------------------------------------------------------------------------
 */
/** Returns the label used for the main textual content of HUD. (read-only)
 */
@property (nonatomic, readonly) UILabel *textLabel;

/** Returns the secondary label of the HUD if one exists. (read-only)
 */
@property (nonatomic, readonly) UILabel *detailLabel;

/**---------------------------------------------------------------------------------------
 * @name Managing the Cell’s State
 *  ---------------------------------------------------------------------------------------
 */
/** Add the specified angle (in radians) to the circular progress view.
 @param rotationDelta The angle, in radians, that will be added to the circular progress view.
 */
- (void)addProgression:(CGFloat)rotationDelta;

@end

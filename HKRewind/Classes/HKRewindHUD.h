//
//  HKRewindHUD.h
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
#import "HKRewindView.h"

@interface HKRewindHUD : UIView

/** Returns the HUD associated with a specific view.
 
 When called on a view for the first time, this method will create a HKRewindHUD and add it as a subview with a 0 alpha. At subsequent calls, it will search the instance in the subviews of the view and return the same HUD.

 @param view The view where the HUD will be shown.
 @return A HKRewindHUD ready to be used.
 */
+ (instancetype)HUDForView:(UIView *)view;

/** Displays the HUD on its subview.
 
 If animated, the alpha value will fade from 0 to 1. This call also brings the HKRewindHUD to the front of its superview.
 @param animated Whether the appearance will be animated or not.
 */
- (void)showHUDAnimated:(BOOL)animated;

/** Hides the HUD on from its subview.

 If animated, the alpha value will fade from 1 to 0. This call also brings the HKRewindHUD to the front of its superview.
 @param animated Whether the appearance will be animated or not.
 */
- (void)hideHUDAnimated:(BOOL)animated;

/**
 The underlying HKRewindView that is displayed.
 
 Use this property to customize the HUD's display and make changes to the circular progress view.
 */
@property (nonatomic, readonly) HKRewindView *rewindView;

/**
 The fade-in/fade-out animation duration.
 */
@property (nonatomic, assign) NSTimeInterval animationDuration      UI_APPEARANCE_SELECTOR;

/**
 The fade-in/fade-out animation delay.
 */
@property (nonatomic, assign) NSTimeInterval animationDelay         UI_APPEARANCE_SELECTOR;

@end

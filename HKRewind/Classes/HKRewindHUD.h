//
//  HKRewindHUD.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRewindView.h"

@interface HKRewindHUD : UIView

+ (instancetype)HUDForView:(UIView *)view;

- (void)showHUDAnimated:(BOOL)animated;
- (void)hideHUDAnimated:(BOOL)animated;

@property (nonatomic, readonly) HKRewindView *rewindView;

@property (nonatomic, assign) NSTimeInterval animationDuration      UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTimeInterval animationDelay         UI_APPEARANCE_SELECTOR;

@end

//
//  HKRewindHUD.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindHUD.h"

@interface HKRewindHUD ()

@property (nonatomic, strong) HKRewindView *rewindView;

@end

@implementation HKRewindHUD

- (void)_defaultInit
{
    self.animationDelay = .0;
    self.animationDuration = .25;
    self.rewindView.textLabel.text = @"Rewind";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _defaultInit];
    }
    return self;
}

- (HKRewindView *)rewindView
{
    if (!_rewindView)
    {
        _rewindView = [[HKRewindView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self addSubview:_rewindView];
    }

    return _rewindView;
}

+ (instancetype)HUDForView:(UIView *)view
{
    HKRewindHUD *hudView = nil;
    NSEnumerator *reverseEnumerator = view.subviews.reverseObjectEnumerator;
    for (UIView *subview in reverseEnumerator)
    {
        if ([subview isKindOfClass:[self class]])
        {
            hudView = (HKRewindHUD *)subview;

            break;
        }
    }
    if (!hudView)
    {
        hudView = [[HKRewindHUD alloc] initWithFrame:CGRectZero];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:hudView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:hudView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:hudView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:200];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:hudView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:200];
        hudView.alpha = .0;
        hudView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:hudView];
        [view bringSubviewToFront:hudView];
        [view addConstraints:@[centerX, centerY, width, height]];
    }
    
    return hudView;
}

- (void)showHUDAnimated:(BOOL)animated
{
    [self.superview bringSubviewToFront:self];
    if (animated)
    {
        [UIView animateWithDuration:self.animationDuration
                              delay:self.animationDelay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1.;
                         }
                         completion:^(BOOL finished){

                         }];
    }
    else
    {
        self.alpha = 1.;
    }
}

- (void)hideHUDAnimated:(BOOL)animated
{
    [self.superview bringSubviewToFront:self];
    if (animated)
    {
        [UIView animateWithDuration:self.animationDuration
                              delay:self.animationDelay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = .0;
                         }
                         completion:^(BOOL finished){

                         }];
    }
    else
    {
        self.alpha = .0;
    }
}

@end

//
//  HKRewindHUD.m
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
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
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
        _rewindView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rewindView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_rewindView)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rewindView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_rewindView)];
        [self addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
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
        hudView = [[self alloc] initWithFrame:CGRectZero];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:hudView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:.0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:hudView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:hudView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute                                                                 multiplier:1.
                                                                   constant:200.];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:hudView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.
                                                                  constant:200.];
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

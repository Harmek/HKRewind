//
//  HKRewindView.m
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


#import "HKRewindView.h"

@interface HKRewindView ()

@property (nonatomic, strong) HKCircularProgressView *circularProgressView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation HKRewindView
@synthesize backgroundView = _backgroundView;

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView)
    {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }

    _backgroundView = backgroundView;
    _backgroundView.frame = self.frame;
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_backgroundView];
    NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(_backgroundView)];
    NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(_backgroundView)];
    [self addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, _backgroundView.bounds);
    shapeLayer.fillColor = [[UIColor colorWithWhite:1 alpha:.5] CGColor];
    shapeLayer.path = path;
    [_backgroundView.layer setMask:shapeLayer];

}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
        [backgroundView setBackgroundColor:[UIColor grayColor]];
        [self setBackgroundView:backgroundView];
    }

    return _backgroundView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self.backgroundView addSubview:_contentView];

        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_contentView)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_contentView)];
        [self.backgroundView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
    }

    return _contentView;
}

- (HKCircularProgressView *)circularProgressView
{
    if (!_circularProgressView)
    {
        _circularProgressView = [[HKCircularProgressView alloc] initWithFrame:CGRectZero];
        _circularProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        _circularProgressView.fillRadius = 1.;
        _circularProgressView.progressTintColor = [UIColor colorWithWhite:0 alpha:1];
        [_circularProgressView setMax:2 * M_PI animated:NO];
        [_circularProgressView setCurrent:2 * M_PI animated:NO];
        [self.contentView addSubview:_circularProgressView];
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_circularProgressView]-5-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_circularProgressView)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_circularProgressView]-5-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_circularProgressView)];
        [self.contentView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
        [self.contentView sendSubviewToBack:_circularProgressView];
    }

    return _circularProgressView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.font = [UIFont boldSystemFontOfSize:17];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_textLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_textLabel
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0];
        [self.contentView addConstraints:@[centerX, centerY]];
        [self.contentView bringSubviewToFront:_textLabel];
    }

    return _textLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_detailLabel];
        UILabel *textLabel = self.textLabel;
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel]-[_detailLabel]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_detailLabel, textLabel)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_detailLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_detailLabel)];
        [self.contentView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
        [self.contentView bringSubviewToFront:_detailLabel];
    }

    return _detailLabel;
}

- (void)addProgression:(CGFloat)rotationDelta
{
    [self.circularProgressView setCurrent:(self.circularProgressView.current + rotationDelta) animated:NO];
}

@end

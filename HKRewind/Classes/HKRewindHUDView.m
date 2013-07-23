//
//  HKRewindHUDView.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/5/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindHUDView.h"

@interface HKRewindHUDView ()

@property (nonatomic, strong) HKCircularProgressView *circularProgressView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation HKRewindHUDView

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [_backgroundView setBackgroundColor:[UIColor grayColor]];
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

    return _backgroundView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.frame];
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
        _circularProgressView = [[HKCircularProgressView alloc] initWithFrame:self.frame];
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

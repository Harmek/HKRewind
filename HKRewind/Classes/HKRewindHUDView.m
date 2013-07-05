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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [_backgroundView setBackgroundColor:[UIColor colorWithWhite:.0 alpha:.3]];
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
        [self.contentView addSubview:_circularProgressView];
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_circularProgressView]-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_circularProgressView)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_circularProgressView]-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_circularProgressView)];
        [self.contentView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
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
        UILabel *detailLabel = self.detailLabel;
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textLabel]-[detailLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_textLabel, detailLabel)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_textLabel)];
        [self.contentView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
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

        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_detailLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_detailLabel)];
        NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_detailLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_detailLabel)];
        [self.contentView addConstraints:[vertConstraints arrayByAddingObjectsFromArray:horiConstraints]];
    }

    return _detailLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

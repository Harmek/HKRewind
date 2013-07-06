//
//  HKRewindHUDView.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/5/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HKCircularProgressView.h>

@interface HKRewindHUDView : UIView

@property (nonatomic, readonly) HKCircularProgressView *circularProgressView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, copy) NSString *rewindDisplayText;
@property (nonatomic, copy) NSString *forwardDisplayText;

- (void)addProgression:(CGFloat)rotationDelta;

@end

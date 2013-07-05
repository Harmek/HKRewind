//
//  HKRewindGestureRecognizer.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKRewindGestureRecognizer;
@protocol HKRewindTriggerDelegate;
@protocol HKRewindTrigger <NSObject>

@property (nonatomic, weak) id<HKRewindTriggerDelegate> delegate;

- (void)reset;

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesBegan:(NSSet *)touches
                        atPoint:(CGPoint)point;

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesMoved:(NSSet *)touches
                        atPoint:(CGPoint)point;

@end

@protocol HKRewindTriggerDelegate <NSObject>

- (void)rewindTriggerRecognized:(id<HKRewindTrigger>)trigger;

@end

@interface HKRewindTriggerPoints : NSObject<HKRewindTrigger>

@property (nonatomic, assign) NSUInteger nbPointsTrigger;

@end

@interface HKRewindTriggerDistance : NSObject<HKRewindTrigger>

@property (nonatomic, assign) CGFloat distanceTrigger;

@end

@interface HKRewindTriggerTime : NSObject<HKRewindTrigger>

@property (nonatomic, assign) NSTimeInterval timeTrigger;

@end


typedef NS_ENUM(NSUInteger, HKRewindTriggerType)
{
    HKRewindTriggerTypePoints = 0,
    HKRewindTriggerTypeDistance,
    HKRewindTriggerTypeTime,
    HKRewindTriggerTypeCustom,

    HKRewindTriggerTypeMax
};

@interface HKRewindGestureRecognizer : UIGestureRecognizer <HKRewindTriggerDelegate>

/**
 * The number of fingers that must be touching the view for this gesture to be recognized.
 */
@property (nonatomic, assign) NSUInteger numberOfTouchesRequired;


/**
 * The number of seconds the user is allowed to be inactive before the recognizer is cancelled.
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 * The number of points (CGPoint) that the gesture recognizer stores in order to run the recognition algorithm.
 * Be aware that the recognizer performs a bounding-box computation everytime a point is added with a complexity of, as of current state, O(n) over this collection.
 */
@property (nonatomic, assign) NSUInteger bufferSize;


/**
 * The condition that will trigger the recognizer while the user describes a curved gesture on the view.
 * It can either be the number of points, the distance traveled by the fingers, the time or any custom trigger.
 */
@property (nonatomic, assign) HKRewindTriggerType triggerType;

/**
 * The object responsible for triggering the recognition.
 * Use this parameter to set a custom trigger or customize the one in place.
 * Use the triggerType parameter to determine the type of the trigger.
 */
@property (nonatomic, strong) id<HKRewindTrigger> trigger;
@end

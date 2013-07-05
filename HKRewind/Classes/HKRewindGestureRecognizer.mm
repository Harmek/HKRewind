//
//  HKRewindGestureRecognizer.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "PointTrail.h"


#pragma mark — Rewind Trigger Points

@interface HKRewindTriggerPoints ()
@property (nonatomic, assign) NSUInteger nbPoints;
@end

@implementation HKRewindTriggerPoints
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.nbPointsTrigger = 5;
    }

    return self;
}

- (void)reset
{
    self.nbPoints = 0;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesBegan:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    ++self.nbPoints;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesMoved:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    ++self.nbPoints;
    if (self.nbPoints >= self.nbPointsTrigger)
    {
        [self.delegate rewindTriggerRecognized:self];
        [self reset];
    }
}

@end


#pragma mark — Rewind Trigger Distance

@interface HKRewindTriggerDistance ()

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat distanceSq;
@property (nonatomic, assign) CGFloat distanceSqTrigger;

@end

@implementation HKRewindTriggerDistance
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.distanceTrigger = 100;
    }

    return self;
}

- (void)reset
{
    self.distanceSq = .0;
}

- (void)setDistanceTrigger:(CGFloat)distanceTrigger
{
    if (distanceTrigger == _distanceTrigger)
        return;

    _distanceTrigger = distanceTrigger;
    self.distanceSqTrigger = distanceTrigger * distanceTrigger;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesBegan:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    self.lastPoint = point;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesMoved:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    CGPoint lastPoint = self.lastPoint;
    self.distanceSq += point.x * lastPoint.x + point.y * lastPoint.y;
    self.lastPoint = point;

    if (self.distanceSq >= self.distanceSqTrigger)
    {
        [self.delegate rewindTriggerRecognized:self];
        [self reset];
    }
}

@end


#pragma mark — Rewind Trigger Time

@interface HKRewindTriggerTime ()

@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval currentTime;

@end

@implementation HKRewindTriggerTime
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.timeTrigger = 1.;
    }

    return self;
}

- (void)reset
{
    self.currentTime = .0;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesBegan:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    NSParameterAssert(touches.count);
    
    UITouch *touch = [touches anyObject];
    self.lastTime = touch.timestamp;
}

- (void)rewindGestureRecognizer:(HKRewindGestureRecognizer *)recognizer
                   touchesMoved:(NSSet *)touches
                        atPoint:(CGPoint)point
{
    NSParameterAssert(touches.count);
    
    UITouch *touch = [touches anyObject];
    self.currentTime += (touch.timestamp - self.lastTime);
    self.lastTime = touch.timestamp;

    if (self.currentTime >= self.timeTrigger)
    {
        [self.delegate rewindTriggerRecognized:self];
        [self reset];
    }
}

@end

#pragma mark — Rewind Gesture Recognizer

@interface HKRewindGestureRecognizer ()
{
    HKRewind::PointTrail m_pointTrail;
}

@property (nonatomic, assign) NSTimeInterval lastTimestamp;

@end

@implementation HKRewindGestureRecognizer
@synthesize trigger = _trigger;

- (void)_defaultInit
{
    self.numberOfTouchesRequired = 2;
    self.timeout = 1;
    self.bufferSize = 16;
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

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (void)setBufferSize:(NSUInteger)bufferSize
{
    m_pointTrail.SetBufferSize(bufferSize);
}

- (NSUInteger)bufferSize
{
    return m_pointTrail.GetBufferSize();
}

- (BOOL)computeTouch:(CGPoint *)touch fromTouches:(NSSet *)touches
{
    if (touches.count != self.numberOfTouchesRequired)
    {
        return NO;
    }

    NSArray *allTouches = [touches allObjects];
    CGPoint touchPoint = CGPointZero;
    for (UITouch *touch in allTouches)
    {
        CGPoint point = [touch locationInView:self.view];
        touchPoint.x += point.x;
        touchPoint.y += point.y;
    }

    touch->x = touchPoint.x / (CGFloat)touches.count;
    touch->y = touchPoint.y / (CGFloat)touches.count;

    return YES;
}

- (id<HKRewindTrigger>)trigger
{
    if (!_trigger)
    {
        switch (self.triggerType)
        {
            case HKRewindTriggerTypePoints:
            {
                _trigger =  [[HKRewindTriggerPoints alloc] init];
                break;
            }

            case HKRewindTriggerTypeDistance:
            {
                _trigger =  [[HKRewindTriggerDistance alloc] init];
                break;
            }

            case HKRewindTriggerTypeTime:
            {
                _trigger =  [[HKRewindTriggerTime alloc] init];
                break;
            }
                
            default:
                break;
        }

        [_trigger setDelegate:self];
    }

    return _trigger;
}

- (void)setTrigger:(id<HKRewindTrigger>)trigger
{
    if (_trigger == trigger)
        return;

    _trigger = trigger;
    [_trigger setDelegate:self];
}

- (void)reset
{
    self.lastTimestamp = .0;
    [self.trigger reset];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = CGPointZero;
    if ([self computeTouch:&touchPoint fromTouches:touches])
    {
        self.state = UIGestureRecognizerStatePossible;
        self.lastTimestamp = [[touches anyObject] timestamp];
        m_pointTrail.AddPoint(touchPoint);
        [self.trigger rewindGestureRecognizer:self
                                 touchesBegan:touches
                                      atPoint:touchPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint touchPoint = CGPointZero;
    if (![self computeTouch:&touchPoint fromTouches:touches])
    {
        self.state = UIGestureRecognizerStateEnded;
        
        return;
    }
    
    NSTimeInterval timestamp = [[touches anyObject] timestamp];
    if (timestamp - self.lastTimestamp > self.timeout)
    {
        self.state = UIGestureRecognizerStateCancelled;

        return;
    }

    self.lastTimestamp = timestamp;
    m_pointTrail.AddPoint(touchPoint);
    if (m_pointTrail.RespectsCurveThreshold())
    {
//        NSLog(@"BINGO");
        [self.trigger rewindGestureRecognizer:self
                                 touchesMoved:touches
                                      atPoint:touchPoint];
    }
    else
    {
//        NSLog(@"WTF");
    }
}

- (void)rewindTriggerRecognized:(id<HKRewindTrigger>)trigger
{
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    m_pointTrail.Clear();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    m_pointTrail.Clear();
}

@end

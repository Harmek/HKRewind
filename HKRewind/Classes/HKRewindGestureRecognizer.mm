//
//  HKRewindGestureRecognizer.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "HKArcPoints.h"
#import "HKGeometryHelpers.h"

#pragma mark — Rewind Gesture Recognizer

@interface HKRewindGestureRecognizer ()
{
    HKArcPoints m_arcPoints;
}

@property (nonatomic, assign) CGFloat rotationDelta;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) CGPoint previousTouch;
@property (nonatomic, assign) CGPoint center;

@end

#define BUFFER_SIZE 16

@implementation HKRewindGestureRecognizer

- (void)_defaultInit
{
    self.numberOfTouchesRequired = 2;
    self.timeout = 1;
    self.maximumRadius = 200;
    self.maximumRotationDelta = M_PI / 50;
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

- (BOOL)clockwise
{
    return self.rotationDelta > 0;
}

/**
 * Used to compute the center of all the current touches.
 * Returns whether the number of touches is equal to the required number or not.
 */
- (BOOL)computeTouch:(CGPoint *)touch fromTouches:(NSSet *)touches
{
    if (touches.count != self.numberOfTouchesRequired)
    {
        return NO;
    }

    if (self.numberOfTouchesRequired == 1)
    {
        *touch = [[touches anyObject] locationInView:self.view];

        return YES;
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

- (void)reset
{
    self.center = CGPointMake(NAN, NAN);
    self.lastTimestamp = .0;
    self.rotationDelta = .0;
    self.velocity = .0;
    m_arcPoints.Clear();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = CGPointZero;
    if ([self computeTouch:&touchPoint fromTouches:touches])
    {
        self.state = UIGestureRecognizerStatePossible;
        self.lastTimestamp = [[touches anyObject] timestamp];
        self.center = CGPointMake(NAN, NAN);
        self.previousTouch = touchPoint;
        m_arcPoints.AddPoint(touchPoint);
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

    if (!m_arcPoints.AddPoint(touchPoint))
        return;

    self.rotationDelta = .0;
    if (CGPointIsNaN(self.center) || CGPointDistance(self.center, touchPoint) > self.maximumRadius)
    {
        CGPoint center = CGPointZero;
        if (!m_arcPoints.TryComputeCenter(&center))
            return;
        self.center = center;
    }

    CGPoint previousVector = CGPointNormalize(self.previousTouch - self.center);
    CGPoint currentVector = CGPointNormalize(touchPoint - self.center);
    CGFloat rotationDelta = CGPointSignedAngle(previousVector, currentVector);
    self.rotationDelta = fmax(-self.maximumRotationDelta, fmin(rotationDelta, self.maximumRotationDelta));

    self.previousTouch = touchPoint;
    self.state = self.state == UIGestureRecognizerStatePossible ? UIGestureRecognizerStateBegan : UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    self.state = UIGestureRecognizerStateEnded;
}

@end

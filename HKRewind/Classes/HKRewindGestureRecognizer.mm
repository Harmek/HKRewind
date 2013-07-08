//
//  HKRewindGestureRecognizer.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import <vector>
#import <numeric>

#pragma mark — CGPoint additions

static CGFloat CGPointDot(CGPoint a, CGPoint b)
{
    return a.x * b.x + a.y * b.y;
}

static CGFloat CGPointLength(CGPoint p)
{
    return sqrt(CGPointDot(p, p));
}

static CGPoint CGPointNormalize(CGPoint p)
{
    CGFloat length = CGPointLength(p);
    
    return CGPointMake(p.x / length, p.y / length);
}

static CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static CGPoint CGPointSubtract(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static CGPoint CGPointScale(CGPoint a, CGFloat f)
{
    return CGPointMake(a.x * f, a.y * f);
}

static CGFloat CGPointDistance(CGPoint a, CGPoint b)
{
    return CGPointLength(CGPointSubtract(a, b));
}

static CGFloat CGPointSignedAngle(CGPoint a, CGPoint b)
{
    CGFloat sinValue = a.x * b.y - a.y * b.x;
    CGFloat cosValue = CGPointDot(a, b);
    
    return atan2(sinValue, cosValue);
}

CGPoint operator+(CGPoint lhs, const CGPoint& rhs)
{
    return CGPointAdd(lhs, rhs);
}

#pragma mark — Rewind Gesture Recognizer

@interface HKRewindGestureRecognizer ()
{
    std::vector<CGPoint> m_points;
}

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat rotationDelta;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) NSUInteger currentState;
@property (nonatomic, assign) CGPoint previousTouch;
@property (nonatomic, assign) CGPoint initialTouch;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

@end

#define BUFFER_SIZE 32

@implementation HKRewindGestureRecognizer

- (void)_defaultInit
{
    self.numberOfTouchesRequired = 2;
    self.timeout = 1;
    self.maximumRadius = 150;
    self.minimumRadius = 50;
    self.threshold = M_PI * .05;
    m_points.reserve(BUFFER_SIZE);
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
    self.lastTimestamp = .0;
    self.rotation = .0;
    self.rotationDelta = .0;
    self.velocity = .0;
    m_points.clear();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = CGPointZero;
    if ([self computeTouch:&touchPoint fromTouches:touches])
    {
        self.state = UIGestureRecognizerStatePossible;
        self.lastTimestamp = [[touches anyObject] timestamp];

        self.initialTouch = touchPoint;
        self.previousTouch = touchPoint;
        m_points.push_back(touchPoint);
//
//        CGPoint viewCenter = CGPointMake(CGRectGetMidX(self.view.bounds),
//                                         CGRectGetMidY(self.view.bounds));
//        CGPoint vectToCenter = CGPointNormalize(CGPointSubtract(viewCenter, touchPoint));
//        self.center = CGPointAdd(touchPoint, CGPointScale(vectToCenter, (self.minimumRadius + self.maximumRadius) * .5));
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

    NSAssert(m_points.size(), nil);
    
    CGPoint lastPoint = m_points.back();
    self->m_points.push_back(touchPoint);
    if (m_points.size() >= BUFFER_SIZE)
    {
        CGPoint arcCenter = std::accumulate(m_points.begin(), m_points.end(), CGPointZero);
        arcCenter = CGPointScale(arcCenter, 1. / m_points.size());
        CGPoint midPoint = CGPointScale(CGPointAdd(m_points.back(), m_points.front()), .5);
        CGPoint vectorToCenter = CGPointNormalize(CGPointSubtract(midPoint, arcCenter));
        self.center = CGPointAdd(arcCenter, CGPointScale(vectorToCenter, self.maximumRadius));
        m_points.clear();
        m_points.push_back(touchPoint);
    }
    else
    {
        if (self.state == UIGestureRecognizerStatePossible)
            return;
    }

    CGPoint previousVector = CGPointNormalize(CGPointSubtract(lastPoint, self.center));
    CGPoint currentVector = CGPointNormalize(CGPointSubtract(touchPoint, self.center));
    self.rotation = atan2(currentVector.y, currentVector.x);
    self.rotationDelta = CGPointSignedAngle(previousVector, currentVector);
    if (self.state == UIGestureRecognizerStatePossible)
        self.state = UIGestureRecognizerStateBegan;
    else
        self.state = UIGestureRecognizerStateChanged;
}

@end

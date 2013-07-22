//
//  HKRewindGestureRecognizer.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import <deque>
#import <vector>
#import <numeric>
#import <functional>

#pragma mark — CGPoint additions

static CGFloat CGPointDeterminant(CGPoint a, CGPoint b)
{
    return a.x * b.y - a.y * b.x;
}

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

static CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointAdd(lhs, rhs);
}

static CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointSubtract(lhs, rhs);
}

static CGPoint operator*(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, k);
}

static CGPoint operator*(CGFloat k, const CGPoint& rhs)
{
    return CGPointScale(rhs, k);
}

static CGPoint operator/(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, 1. / k);
}

static bool CGPointHigherThan(CGPoint a, CGPoint b)
{
    return a.y > b.y;
}

static bool CGPointIsNaN(CGPoint point)
{
    return isnan(point.x) || isnan(point.y);
}

static CGPoint CGPointRotateAround(CGPoint point, CGPoint pivot, CGFloat angle)
{
    CGPoint result = CGPointApplyAffineTransform(point - pivot,
                                                 CGAffineTransformMakeRotation(angle));
    result = result + pivot;

    return result;
}

#pragma mark — HKLine

struct HKLine
{
    CGPoint point;
    CGPoint vector;

    typedef enum IntersectionType
    {
        IntersectionTypeColinear = 0,
        IntersectionTypeOverlap,
        IntersectionTypePoint,

        IntersectionTypeMax
    } IntersectionType;

    inline HKLine(CGPoint point, CGPoint vector)
    : point(point)
    , vector(vector)
    {
        assert(!CGPointIsNaN(point));
        assert(!CGPointIsNaN(vector));
    }

    inline static IntersectionType Intersect(const HKLine& u, const HKLine& v, CGPoint *intersection)
    {
//        CGFloat determinant = u.a * v.b - v.a * u.b;
//        if(determinant == .0)
//        {
//            return IntersectionTypeColinear;
//        }
//        else
//        {
//            if (intersection)
//            {
//                intersection->x = (v.b * u.c - u.b * v.c) / determinant;
//                intersection->y = (u.a * v.c - v.a * u.c) / determinant;
////                NSLog(@"%@", NSStringFromCGPoint(*intersection));
//                NSLog(@"%f", determinant);
//            }
//
//            return IntersectionTypePoint;
//        }
        CGFloat determinant = CGPointDeterminant(u.vector, v.vector);

        if (determinant == .0)
        {
            if (CGPointDeterminant(v.point - u.point, v.vector) == .0)
            {
                return IntersectionTypeOverlap;
            }

            return IntersectionTypeColinear;
        }

        // p + t r = q + u s
        // We need k and l such as "u.point + k * u.vector = v.point + l * v.vector"
        CGFloat k = CGPointDeterminant((v.point - u.point), v.vector) / CGPointDeterminant(u.vector, v.vector);
//        CGFloat l = CGPointDeterminant((v.point - u.point), u.vector) / CGPointDeterminant(u.vector, v.vector);

        if (intersection)
        {
            *intersection = u.point + u.vector * k;
//            NSLog(@"%@ + %f * %@", NSStringFromCGPoint(u.point), k, NSStringFromCGPoint(u.vector));
        }
        return IntersectionTypePoint;
    }

    inline IntersectionType Intersects(const HKLine& other, CGPoint *intersection) const
    {
        return HKLine::Intersect(*this, other, intersection);
    }
};

struct HKApplyTransform : public std::unary_function<CGPoint, CGPoint>
{
    inline HKApplyTransform(const CGAffineTransform& transform)
    : m_transform(transform)
    {
    }

    inline CGPoint operator() (const CGPoint& point) const
    {
        return CGPointApplyAffineTransform(point, m_transform);
    }

private:
    const CGAffineTransform& m_transform;
};

static HKLine GetBisector(CGPoint a, CGPoint b)
{
    CGPoint segmentMiddle = (a + b) * .5;
    CGPoint bisectSecondPoint = CGPointRotateAround(b, segmentMiddle, M_PI_2);
    assert(!CGPointEqualToPoint(bisectSecondPoint, segmentMiddle));
    CGPoint bisectVector = CGPointNormalize(bisectSecondPoint - segmentMiddle);
    HKLine bisector = HKLine(segmentMiddle, bisectVector);

    return bisector;
}

#pragma mark — Rewind Gesture Recognizer

@interface HKRewindGestureRecognizer ()
{
    std::deque<CGPoint> m_points;
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

#define BUFFER_SIZE 16

@implementation HKRewindGestureRecognizer

- (void)_defaultInit
{
    self.numberOfTouchesRequired = 2;
    self.timeout = 1;
    self.maximumRadius = 150;
    self.minimumRadius = 50;
    self.threshold = M_PI * .05;
//    m_points.reserve(BUFFER_SIZE);
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

    self->m_points.push_back(touchPoint);
    if (m_points.size() < BUFFER_SIZE)
        return;
    while (m_points.size() > BUFFER_SIZE)
        m_points.pop_front();

    if (!CGPointIsNaN(self.center) && CGPointDistance(self.center, touchPoint) < self.minimumRadius)
        return;
    
    CGPoint oldestPoint = m_points.front();
    CGPoint latestPoint = m_points.back();
    CGPoint arcVector = CGPointNormalize(latestPoint - oldestPoint);
    CGFloat rotation = atan2(arcVector.y, arcVector.x);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-oldestPoint.x, -oldestPoint.y);
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(-rotation));

    std::vector<CGPoint> transformedPoints;
    transformedPoints.resize(m_points.size());
    std::transform(m_points.begin(),
                   m_points.end(),
                   transformedPoints.begin(),
                   HKApplyTransform(transform));
    CGPoint tipPoint = *std::max_element(++transformedPoints.begin(),
                                         --transformedPoints.end(),
                                         CGPointHigherThan);
    tipPoint = CGPointApplyAffineTransform(tipPoint, CGAffineTransformInvert(transform));
    NSLog(@"%f", CGPointDot(CGPointNormalize(oldestPoint - tipPoint), CGPointNormalize(tipPoint - latestPoint)));
    HKLine firstBisector = GetBisector(oldestPoint, tipPoint);
    HKLine secondBisector = GetBisector(tipPoint, latestPoint);
    CGPoint center = CGPointZero;

    if (HKLine::Intersect(firstBisector, secondBisector, &center) == HKLine::IntersectionTypePoint)
    {
        self.center = center;
        self.state = UIGestureRecognizerStateChanged;
        m_points.clear();
        m_points.push_back(touchPoint);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    self.state = UIGestureRecognizerStateEnded;
}

@end

//
//  HKGeometryHelpers.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#ifndef __HKRewind__HKGeometryHelpers__
#define __HKRewind__HKGeometryHelpers__

#include <functional>

#pragma mark — CGPoint additional functions and overloads

CGFloat CGPointDeterminant(CGPoint a, CGPoint b);
CGFloat CGPointDot(CGPoint a, CGPoint b);
CGFloat CGPointLength(CGPoint p);
CGPoint CGPointNormalize(CGPoint p);
CGPoint CGPointAdd(CGPoint a, CGPoint b);
CGPoint CGPointSubtract(CGPoint a, CGPoint b);
CGPoint CGPointScale(CGPoint a, CGFloat f);
CGFloat CGPointDistance(CGPoint a, CGPoint b);
CGFloat CGPointSignedAngle(CGPoint a, CGPoint b);
CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs);
CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs);
CGPoint operator*(const CGPoint& lhs, CGFloat k);
CGPoint operator*(CGFloat k, const CGPoint& rhs);
CGPoint operator/(const CGPoint& lhs, CGFloat k);
bool CGPointYLessThan(CGPoint a, CGPoint b);
bool CGPointYGreaterThan(CGPoint a, CGPoint b);
bool CGPointXGreaterThan(CGPoint a, CGPoint b);
bool CGPointXLessThan(CGPoint a, CGPoint b);
bool CGPointIsNaN(CGPoint point);
CGPoint CGPointRotateAround(CGPoint point, CGPoint pivot, CGFloat angle);

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

    HKLine(CGPoint point, CGPoint vector);

    static IntersectionType Intersect(const HKLine& u, const HKLine& v, CGPoint *intersection);
    IntersectionType Intersects(const HKLine& other, CGPoint *intersection) const;
};

struct HKApplyTransform : public std::unary_function<CGPoint, CGPoint>
{
    HKApplyTransform(const CGAffineTransform& transform);
    CGPoint operator() (const CGPoint& point) const;

private:
    const CGAffineTransform& m_transform;
};

HKLine GetBisector(CGPoint a, CGPoint b);

#endif /* defined(__HKRewind__HKGeometryHelpers__) */

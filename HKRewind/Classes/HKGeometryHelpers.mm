//
//  HKGeometryHelpers.mm
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


#include "HKGeometryHelpers.h"

#pragma mark — CGPoint additional functions and overloads

CGFloat CGPointDeterminant(CGPoint a, CGPoint b)
{
    return a.x * b.y - a.y * b.x;
}

CGFloat CGPointDot(CGPoint a, CGPoint b)
{
    return a.x * b.x + a.y * b.y;
}

CGFloat CGPointLength(CGPoint p)
{
    return sqrt(CGPointDot(p, p));
}

CGPoint CGPointNormalize(CGPoint p)
{
    CGFloat length = CGPointLength(p);

    return CGPointMake(p.x / length, p.y / length);
}

CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint CGPointSubtract(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint CGPointScale(CGPoint a, CGFloat f)
{
    return CGPointMake(a.x * f, a.y * f);
}

CGFloat CGPointDistance(CGPoint a, CGPoint b)
{
    return CGPointLength(CGPointSubtract(a, b));
}

CGFloat CGPointSignedAngle(CGPoint a, CGPoint b)
{
    CGFloat sinValue = a.x * b.y - a.y * b.x;
    CGFloat cosValue = CGPointDot(a, b);

    return atan2(sinValue, cosValue);
}

CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointAdd(lhs, rhs);
}

CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointSubtract(lhs, rhs);
}

CGPoint operator*(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, k);
}

CGPoint operator*(CGFloat k, const CGPoint& rhs)
{
    return CGPointScale(rhs, k);
}

CGPoint operator/(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, 1. / k);
}

bool CGPointYLessThan(CGPoint a, CGPoint b)
{
    return a.y < b.y;
}

bool CGPointYGreaterThan(CGPoint a, CGPoint b)
{
    return a.y > b.y;
}

bool CGPointXGreaterThan(CGPoint a, CGPoint b)
{
    return a.x > b.x;
}

bool CGPointXLessThan(CGPoint a, CGPoint b)
{
    return a.x < b.x;
}

bool CGPointIsNaN(CGPoint point)
{
    return isnan(point.x) || isnan(point.y);
}

CGPoint CGPointRotateAround(CGPoint point, CGPoint pivot, CGFloat angle)
{
    CGPoint result = CGPointApplyAffineTransform(point - pivot,
                                                 CGAffineTransformMakeRotation(angle));
    result = result + pivot;

    return result;
}

HKLine GetBisector(CGPoint a, CGPoint b)
{
    CGPoint segmentMiddle = (a + b) * .5;
    CGPoint bisectSecondPoint = CGPointRotateAround(b, segmentMiddle, M_PI_2);
    CGPoint bisectVector = CGPointNormalize(bisectSecondPoint - segmentMiddle);
    HKLine bisector = HKLine(segmentMiddle, bisectVector);

    return bisector;
}

#pragma mark — HKLine

HKLine::HKLine(CGPoint point, CGPoint vector)
: point(point)
, vector(vector)
{
    assert(!CGPointIsNaN(point));
    assert(!CGPointIsNaN(vector));
}

HKLine::IntersectionType HKLine::Intersect(const HKLine& u, const HKLine& v, CGPoint *intersection)
{
    CGFloat determinant = CGPointDeterminant(u.vector, v.vector);

    if (determinant == .0)
    {
        if (CGPointDeterminant(v.point - u.point, v.vector) == .0)
        {
            return HKLine::IntersectionTypeOverlap;
        }

        return HKLine::IntersectionTypeColinear;
    }

    // We need k and l such as "u.point + k * u.vector = v.point + l * v.vector"
    CGFloat k = CGPointDeterminant((v.point - u.point), v.vector) / CGPointDeterminant(u.vector, v.vector);
    //CGFloat l = CGPointDeterminant((v.point - u.point), u.vector) / CGPointDeterminant(u.vector, v.vector);

    if (intersection)
    {
        *intersection = u.point + u.vector * k;
    }
    return HKLine::IntersectionTypePoint;
}

HKLine::IntersectionType HKLine::Intersects(const HKLine& other, CGPoint *intersection) const
{
    return HKLine::Intersect(*this, other, intersection);
}

HKApplyTransform::HKApplyTransform(const CGAffineTransform& transform)
: m_transform(transform)
{
}

CGPoint HKApplyTransform::operator() (const CGPoint& point) const
{
    return CGPointApplyAffineTransform(point, m_transform);
}

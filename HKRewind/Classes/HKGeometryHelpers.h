//
//  HKGeometryHelpers.h
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

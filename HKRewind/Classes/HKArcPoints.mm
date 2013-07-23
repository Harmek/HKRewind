//
//  HKArcPoints.mm
//  HKRewind
//
//  Copyright (c) 2012-2013, Panos Baroudjian.
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


#include "HKArcPoints.h"
#include "HKGeometryHelpers.h"

#include <functional>

HKArcPoints::HKArcPoints(HKArcPoints::Points::size_type bufferSize)
: m_bufferSize(bufferSize)
{
    m_temporaryPoints.resize(bufferSize);
}

void HKArcPoints::Clear()
{
    m_points.clear();
}

bool HKArcPoints::AddPoint(CGPoint point)
{
    m_points.push_back(point);

    if (m_points.size() < m_bufferSize)
        return false;

    while (m_points.size() > m_bufferSize)
        m_points.pop_front();

    return true;
}

bool HKArcPoints::TryComputeCenter(CGPoint *outCenter, CGFloat tolerance)
{
    CGPoint oldestPoint = m_points.front();
    CGPoint latestPoint = m_points.back();

    if (CGPointEqualToPoint(oldestPoint, latestPoint))
        return NO;
    
    CGPoint arcVector = CGPointNormalize(latestPoint - oldestPoint);
    CGFloat rotation = atan2(arcVector.y, arcVector.x);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-oldestPoint.x, -oldestPoint.y);
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(-rotation));

    std::transform(m_points.begin(),
                   m_points.end(),
                   m_temporaryPoints.begin(),
                   HKApplyTransform(transform));
    CGPoint tipPoint = *std::max_element(++m_temporaryPoints.begin(),
                                         --m_temporaryPoints.end(),
                                         CGPointYLessThan);
    tipPoint = CGPointApplyAffineTransform(tipPoint, CGAffineTransformInvert(transform));
    CGFloat dotValue = CGPointDot(CGPointNormalize(oldestPoint - tipPoint), CGPointNormalize(tipPoint - latestPoint));
    if (fabs(dotValue) > tolerance)
        return false;

    if (CGPointEqualToPoint(oldestPoint, tipPoint) || CGPointEqualToPoint(latestPoint, tipPoint))
        return NO;
    
    HKLine firstBisector = GetBisector(oldestPoint, tipPoint);
    HKLine secondBisector = GetBisector(tipPoint, latestPoint);
    if (HKLine::Intersect(firstBisector, secondBisector, outCenter) != HKLine::IntersectionTypePoint)
        return false;

    return true;
}
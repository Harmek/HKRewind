//
//  HKArcPoints.mm
//  HKRewind
//
//  Created by Panos Baroudjian on 7/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#include "HKArcPoints.h"
#include "HKGeometryHelpers.h"

HKArcPoints::HKArcPoints(HKArcPoints::Points::size_type bufferSize)
: m_bufferSize(bufferSize)
{

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

bool HKArcPoints::TryComputeCenter(CGPoint *outCenter, CGFloat tolerance) const
{
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
                                         CGPointYLessThan);
    tipPoint = CGPointApplyAffineTransform(tipPoint, CGAffineTransformInvert(transform));
    CGFloat dotValue = CGPointDot(CGPointNormalize(oldestPoint - tipPoint), CGPointNormalize(tipPoint - latestPoint));
    if (fabs(dotValue) > tolerance)
        return false;

    HKLine firstBisector = GetBisector(oldestPoint, tipPoint);
    HKLine secondBisector = GetBisector(tipPoint, latestPoint);
    if (HKLine::Intersect(firstBisector, secondBisector, outCenter) != HKLine::IntersectionTypePoint)
        return false;

    return true;
}
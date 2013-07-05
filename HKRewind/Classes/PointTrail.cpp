//
//  PointTrail.cpp
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#include "PointTrail.h"
#include <cmath>

using namespace HKRewind;

PointTrail::PointTrail(size_t bufferSize, CGFloat lineThreshold)
    : m_bufferSize(bufferSize)
    , m_threshold(lineThreshold)
    , m_isDirty(true)
{

}

void PointTrail::AddPoint(CGPoint point)
{
    this->AddPoint(point.x, point.y);
}

void PointTrail::Clear()
{
    m_xCoordinates.clear();
    m_yCoordinates.clear();
}

void PointTrail::AddPoint(CGFloat x, CGFloat y)
{
    m_xCoordinates.push_back(x);
    m_yCoordinates.push_back(y);
    while (m_xCoordinates.size() > m_bufferSize)
    {
        m_xCoordinates.pop_front();
        m_yCoordinates.pop_front();
    }

    m_isDirty = true;
}

bool PointTrail::ComputeBoundsIfNeeded()
{
    if (m_xCoordinates.size() < m_bufferSize)
        return false;

    if (!m_isDirty)
        return true;
    
    auto xMinMax = std::minmax_element(m_xCoordinates.begin(), m_xCoordinates.end());
    auto yMinMax = std::minmax_element(m_yCoordinates.begin(), m_yCoordinates.end());
    m_minX = *(xMinMax.first);
    m_maxX = *(xMinMax.second);
    m_minY = *(yMinMax.first);
    m_maxY = *(yMinMax.second);

    m_isDirty = false;

    return true;
}

bool PointTrail::GetBounds(CGFloat& minX, CGFloat& maxX, CGFloat& minY, CGFloat& maxY)
{
    if (!this->ComputeBoundsIfNeeded())
        return false;
    
    minX = m_minX;
    maxX = m_maxX;
    minY = m_minY;
    maxY = m_maxY;

    return true;
}

static CGFloat DotProduct(CGFloat aX, CGFloat aY, CGFloat bX, CGFloat bY)
{
    return aX * bX + aY * bY;
}

static CGFloat Normalize(CGFloat& x, CGFloat& y)
{
    CGFloat length = std::sqrt(DotProduct(x, y, x, y));
    x /= length;
    y /= length;

    return length;
}

bool PointTrail::RespectsCurveThreshold()
{
    if (!this->ComputeBoundsIfNeeded())
        return false;

    // Center of the bounding box
    CGFloat centerX = (m_minX + m_maxX) * .5;
    CGFloat centerY = (m_minY + m_maxY) * .5;

    // Coordinates of the oldest and most recent stored points
    CGFloat firstX = m_xCoordinates.at(0);
    CGFloat lastX = m_xCoordinates.at(m_xCoordinates.size() - 1);
    CGFloat firstY = m_yCoordinates.at(0);
    CGFloat lastY = m_yCoordinates.at(m_yCoordinates.size() - 1);

    // Normalized vector from the center to the oldest point
    CGFloat uX = firstX - centerX;
    CGFloat uY = firstY - centerY;
    Normalize(uX, uY);

    // Normalized vector from the center to the newest point
    CGFloat vX = lastX - centerX;
    CGFloat vY = lastY - centerY;
    Normalize(vX, vY);

    // The dot-product of 2 normalized vectors gives us the cosinus of the angle between them.
    CGFloat dot = DotProduct(uX, uY, vX, vY);

    return std::abs(dot) < m_threshold;
}

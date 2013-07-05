//
//  PointTrail.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/1/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#ifndef __HKRewind__PointTrail__
#define __HKRewind__PointTrail__

#include <deque>
#include <CoreGraphics/CGGeometry.h>

namespace HKRewind {
    class PointTrail
    {
    public:
        PointTrail(size_t bufferSize = 20, CGFloat threshold = 1.);

        void AddPoint(CGPoint point);
        void AddPoint(CGFloat x, CGFloat y);

        void Clear();

        bool GetBounds(CGFloat& minX, CGFloat& maxX, CGFloat& minY, CGFloat& maxY);

        inline void SetBufferSize(size_t bufferSize) { m_bufferSize = bufferSize; }
        inline size_t GetBufferSize() const { return m_bufferSize; }

        inline void SetThreshold(CGFloat threshold) { m_threshold = threshold; }
        inline CGFloat GetThreshold() const { return m_threshold; }

        bool RespectsCurveThreshold();
        
    private:
        typedef std::deque<CGPoint> Points;
        typedef std::deque<CGFloat> Coordinates;
        size_t m_bufferSize;
        
        Coordinates m_xCoordinates;
        Coordinates m_yCoordinates;

        // Bounds
        CGFloat m_minX, m_maxX, m_minY, m_maxY;

        CGFloat m_threshold;

        bool m_isDirty;

        bool ComputeBoundsIfNeeded();
    };
}

#endif /* defined(__HKRewind__PointTrail__) */

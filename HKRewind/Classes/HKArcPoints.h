//
//  HKArcPoints.h
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


#ifndef __HKRewind__HKArcPoints__
#define __HKRewind__HKArcPoints__

#include <deque>
#include <vector>

/**
 * This class stores a buffer of points supposed to represent an arc. When the buffer is full enough it can compute an approximate center for the circle of the arc.
 */
class HKArcPoints
{
private:
    typedef std::deque<CGPoint> Points;
    typedef std::vector<CGPoint> TemporaryPoints;

    Points m_points;
    Points::size_type m_bufferSize;
    TemporaryPoints m_temporaryPoints;

public:
    HKArcPoints(Points::size_type bufferSize = 16);
    void Clear();

    /**
     * Returns false if the buffer is not full enough
     */
    bool AddPoint(CGPoint point);

    /**
     * Returns false if the center could not be computed. It happens when the points in the buffer are not curved enough.
     * The tolerance parameter ([0..1]) is used in to determine if the points are not curved enough. Higher means more permissive.
     */
    bool TryComputeCenter(CGPoint *outCenter, CGFloat tolerance = .9);
};

#endif /* defined(__HKRewind__HKArcPoints__) */

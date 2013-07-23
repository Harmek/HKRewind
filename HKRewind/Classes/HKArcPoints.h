//
//  HKArcPoints.h
//  HKRewind
//
//  Created by Panos Baroudjian on 7/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#ifndef __HKRewind__HKArcPoints__
#define __HKRewind__HKArcPoints__

#import <deque>
#import <vector>
#import <numeric>

class HKArcPoints
{
private:
    typedef std::deque<CGPoint> Points;
    Points m_points;
    Points::size_type m_bufferSize;

public:
    HKArcPoints(Points::size_type bufferSize = 16);
    void Clear();
    bool AddPoint(CGPoint point);
    bool TryComputeCenter(CGPoint *outCenter, CGFloat tolerance = .9) const;
};

#endif /* defined(__HKRewind__HKArcPoints__) */

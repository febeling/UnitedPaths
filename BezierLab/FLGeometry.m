//
//  FLGeometry.m
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometry.h"

// This function does not check if the point is really 
// a point on the line.
inline
BOOL FLLinePointOnSegment(NSPoint p1, NSPoint p2, NSPoint x)
{
  return MIN(p1.x,p2.x) <= x.x && x.x <= MAX(p1.x, p2.x) &&
         MIN(p1.y,p2.y) <= x.y && x.y <= MAX(p1.y, p2.y);
}

BOOL FLLineSegmentIntersection(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPointPointer x)
{
  CGFloat a1 = p2.y - p1.y;
  CGFloat b1 = p1.x - p2.x;
  CGFloat c1 = a1*p1.x + b1*p1.y;
  
  CGFloat a2 = p4.y - p3.y;
  CGFloat b2 = p3.x - p4.x;
  CGFloat c2 = a2*p3.x + b2*p3.y;
  
  CGFloat det = a1*b2 - a2*b1;

  if(det == 0) { // parallel
    return NO;
  }

  *x = (NSPoint) {(b2*c1 - b1*c2)/det, (a1*c2 - a2*c1)/det};
    
  return FLLinePointOnSegment(p1, p2, *x) && FLLinePointOnSegment(p3, p4, *x);
}

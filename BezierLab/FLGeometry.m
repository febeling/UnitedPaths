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

FLLine FLLineFromPoints(NSPoint p1, NSPoint p2)\
{
  FLLine line;

  line.a = p2.y - p1.y;
  line.b = p1.x - p2.x;
  line.c = line.a*p1.x + line.b*p1.y;
  
  return line;
}

BOOL FLLineSegmentIntersection(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPointPointer x)
{
  FLLine line1 = FLLineFromPoints(p1, p2);
  FLLine line2 = FLLineFromPoints(p3, p4);
  
  CGFloat det = line1.a*line2.b - line2.a*line1.b;

  if(det == 0) { // parallel
    return NO;
  }

  *x = NSMakePoint((line2.b*line1.c - line1.b*line2.c)/det, (line1.a*line2.c - line2.a*line1.c)/det);
    
  return FLLinePointOnSegment(p1, p2, *x) && FLLinePointOnSegment(p3, p4, *x);
}

static
inline
CGFloat CurvePointComponent(CGFloat pt, CGFloat c1, CGFloat c2,CGFloat c3, CGFloat c4)
{
  CGFloat d = 1.0 - pt;
  return pow(d, 3.0) * c1 + 3.0 * pow(d, 2.0) * pt * c2 + 3.0 * d * pow(pt,2.0) * c3 + pow(pt,3.0) * c4;
}

inline
NSPoint FLCurvePoint(NSPoint p, NSPoint c[], CGFloat t)
{
  CGFloat x = CurvePointComponent(t, p.x, c[0].x, c[1].x, c[2].x);
  CGFloat y = CurvePointComponent(t, p.y, c[0].y, c[1].y, c[2].y);
  
  return NSMakePoint(x,y);
}

inline
void FLCurveToSegments(NSPoint start, NSPoint points[], NSUInteger n, FLSegment segments[])
{
  CGFloat previousT = 0.0;
  CGFloat interval = 1.0 / n;
  NSPoint previousPoint = start;
  
  for(int i = 0; i < n; i++) {
    segments[i].t0 = previousT;
    segments[i].t1 = interval * (i+1);
    segments[i].start = previousPoint;
    segments[i].end = FLCurvePoint(start, points,  segments[i].t1);
    previousT = segments[i].t1;
    previousPoint = segments[i].end;
  }
}









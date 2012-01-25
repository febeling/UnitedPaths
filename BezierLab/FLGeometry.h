//
//  FLGeometry.h
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct FLLine {
  CGFloat a;
  CGFloat b;
  CGFloat c;
};
typedef struct FLLine FLLine;

struct FLSegment {
  NSPoint start;
  NSPoint end;
  CGFloat t0;
  CGFloat t1;
};
typedef struct FLSegment FLSegment;

BOOL FLLinePointOnSegment(NSPoint p1, NSPoint p2, NSPoint x);
FLLine FLLineFromPoints(NSPoint p1, NSPoint p2);
BOOL FLLineSegmentIntersection(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPointPointer x);
NSPoint FLCurvePoint(NSPoint start, NSPoint points[], CGFloat t);
void FLCurveToSegments(NSPoint start, NSPoint points[], NSUInteger n, FLSegment segments[]);

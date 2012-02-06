//
//  FLGeometry.h
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLPathSegment.h"

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

struct FLCurve {
  NSPoint startPoint;
  NSPoint controlPoints[3];
};
typedef struct FLCurve FLCurve;

CGFloat FLLineSegmentLength(NSPoint p1, NSPoint p2);
BOOL FLLinePointOnSegment(NSPoint p1, NSPoint p2, NSPoint x);
FLLine FLLineFromPoints(NSPoint p1, NSPoint p2);
BOOL FLIntersectionLineAndLine(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPoint *x);
NSPoint FLCurvePoint(NSPoint start, NSPoint points[], CGFloat t);
void FLCurveToSegments(NSPoint start, NSPoint points[], NSUInteger n, FLSegment segments[]);
BOOL FLPointsAreClose(NSPoint p1, NSPoint p2);
NSPoint FLInterpolateCurvePoint(NSPoint segStart, NSPoint segEnd, NSPoint segIntersec, CGFloat segStartT, CGFloat segEndT, NSPoint curveStart, NSPoint *curvePoints);
CGFloat FLInterpolateCurveT(NSPoint segStart, NSPoint segEnd, NSPoint segIntersec, CGFloat segStartT, CGFloat segEndT, NSPoint curveStart, NSPoint *curvePoints);
NSUInteger FLPathSegmentIntersectionCount(FLPathSegment *segment, FLPathSegment *modifier);
void FLPathSegmentIntersections(FLPathSegment *segment, FLPathSegment *modifier);
NSArray *FLPathElementIntersections(NSBezierPathElement element1,
                                    NSPoint start1,
                                    NSPoint points1[],
                                    NSBezierPathElement element2,
                                    NSPoint start2,
                                    NSPoint points2[],
                                    NSUInteger num,
                                    NSArray **info);
void FLSplitCurveFromPoints(double t, NSPoint p, NSPoint *points, FLCurve **splits);
void FLSplitCurve(double t, FLCurve curve, FLCurve **splits);

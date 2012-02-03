//
//  FLGeometry.m
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometry.h"

#define MAX_INTERSECTIONS_CUBIC 3

inline
BOOL FLLinePointOnSegment(NSPoint p1, NSPoint p2, NSPoint x)
{
  // This function does not check if the point is really 
  // a point on the line.
  return MIN(p1.x,p2.x) <= x.x && x.x <= MAX(p1.x, p2.x) &&
         MIN(p1.y,p2.y) <= x.y && x.y <= MAX(p1.y, p2.y);
}

CGFloat FLLineSegmentLength(NSPoint p1, NSPoint p2)
{
  return sqrt(pow(p2.x-p1.x, 2) + pow(p2.y-p1.y, 2));
}

FLLine FLLineFromPoints(NSPoint p1, NSPoint p2)
{
  FLLine line;

  line.a = p2.y - p1.y;
  line.b = p1.x - p2.x;
  line.c = line.a*p1.x + line.b*p1.y;
  
  return line;
}

BOOL FLIntersectionLineAndLine(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPoint *x)
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
CGFloat PointOnCurveComponent(CGFloat pt, CGFloat c1, CGFloat c2,CGFloat c3, CGFloat c4)
{
  CGFloat d = 1.0 - pt;
  return pow(d, 3.0) * c1 + 3.0 * pow(d, 2.0) * pt * c2 + 3.0 * d * pow(pt,2.0) * c3 + pow(pt,3.0) * c4;
}

inline
NSPoint FLCurvePoint(NSPoint p, NSPoint c[], CGFloat t)
{
  CGFloat x = PointOnCurveComponent(t, p.x, c[0].x, c[1].x, c[2].x);
  CGFloat y = PointOnCurveComponent(t, p.y, c[0].y, c[1].y, c[2].y);
  
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

// TODO find a sensible number of sections, involving calculating curve length.
// Till the use this workaround fixed number:
#define N_SEGMENTS 50

#define MIN_DIST   1.0e-5

BOOL FLPointsAreClose(NSPoint p1, NSPoint p2)
{
  CGFloat d = FLLineSegmentLength(p1, p2);

  return fabs(d) < MIN_DIST;
}

static
NSArray *FLIntersectionsLineAndCurve(NSPoint lineStart, NSPoint lineEnd, NSPoint startCurve, NSPoint* curvePoints, NSUInteger n, NSInteger pos, NSArray **info)
{
  NSMutableArray *array = [NSMutableArray array];
  NSMutableArray *intersectionInfo = [NSMutableArray array];
  FLSegment segments[n];

  FLCurveToSegments(startCurve, curvePoints, n, segments);
  
  BOOL isIntersection = NO;
  NSPoint intersection = NSZeroPoint;
  int numIntersections = 0;
  
  for(int i = 0; i < n; i++) {
    isIntersection = FLIntersectionLineAndLine(lineStart, lineEnd, segments[i].start, segments[i].end, &intersection);
    
    if(isIntersection) {
      CGFloat seglen = FLLineSegmentLength(segments[i].start, segments[i].end); // distance of segment points
      CGFloat x_dist = FLLineSegmentLength(segments[i].start, intersection);    // dist of intersection point from segment start point
      CGFloat x_t = segments[i].t0 + x_dist/seglen*(segments[i].t1-segments[i].t0); // intersection dist in terms of t + t of segment start point
      NSPoint curve_point = FLCurvePoint(startCurve, curvePoints, x_t);

      if(!FLPointsAreClose([[array lastObject] pointValue], curve_point)) {
        numIntersections++;
        [array addObject:[NSValue valueWithPoint:curve_point]];
        [intersectionInfo addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x_t] forKey:[NSString stringWithFormat:@"t%d", pos]]];
        *info = intersectionInfo;

        if(numIntersections == MAX_INTERSECTIONS_CUBIC) break;
      }
    }
  }
  
  return array;
}

CGFloat InterpolateCurveT(NSPoint segStart, NSPoint segEnd, NSPoint segIntersec, CGFloat segStartT, CGFloat segEndT, NSPoint curveStart, NSPoint *curvePoints)
{
  CGFloat seglen = FLLineSegmentLength(segStart, segEnd);
  CGFloat x_dist = FLLineSegmentLength(segStart, segIntersec);
  CGFloat x_t = segStartT + x_dist/seglen*(segEndT-segStartT);

  return x_t;
}

NSPoint InterpolateCurvePoint(NSPoint segStart, NSPoint segEnd, NSPoint segIntersec, CGFloat segStartT, CGFloat segEndT, NSPoint curveStart, NSPoint *curvePoints)
{
  CGFloat x_t = InterpolateCurveT(segStart, segEnd, segIntersec, segStartT, segEndT, curveStart, curvePoints);

  return FLCurvePoint(curveStart, curvePoints, x_t);
}

static
NSArray *FLIntersectionsCurveAndCurve(NSPoint start1, NSPoint *points1, NSPoint start2, NSPoint* points2, NSUInteger n, NSArray **info)
{
  NSMutableArray *array = [NSMutableArray array];
  NSMutableArray *intersectionInfo = [NSMutableArray array];

  FLSegment segments1[n];
  FLSegment segments2[n];
  
  FLCurveToSegments(start1, points1, n, segments1);
  FLCurveToSegments(start2, points2, n, segments2);
  
  BOOL isIntersection = NO;
  NSPoint intersection = NSZeroPoint;
  int numIntersections = 0;
  
  for(int i = 0; i < n; i++) {
    for(int j = 0; j < n; j++) {
      isIntersection = FLIntersectionLineAndLine(segments1[i].start, segments1[i].end,
                                                 segments2[j].start, segments2[j].end,
                                                 &intersection);
      
      if(isIntersection) {
        NSPoint curvePoint = InterpolateCurvePoint(segments1[i].start, segments1[i].end,
                                                   intersection,
                                                   segments1[i].t0, segments1[i].t1,
                                                   start1, points1);
        
        if(!FLPointsAreClose([[array lastObject] pointValue], curvePoint)) {
          numIntersections++;
          [array addObject:[NSValue valueWithPoint:curvePoint]];

          CGFloat t0 = InterpolateCurveT(segments1[i].start, segments1[i].end,
                                         intersection,
                                         segments1[i].t0, segments1[i].t1,
                                         start1, points1);
          CGFloat t1 = InterpolateCurveT(segments2[i].start, segments2[i].end,
                                         intersection,
                                         segments2[i].t0, segments2[i].t1,
                                         start2, points2);
          NSDictionary *intersection = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:t0], @"t0",[NSNumber numberWithDouble:t1], @"t1", nil];
          [intersectionInfo addObject:intersection];
          *info = intersectionInfo;
          
          if(numIntersections == MAX_INTERSECTIONS_CUBIC) break;
        }
      }
    }
  }
  
  return array;
}

NSArray *FLPathElementIntersections(NSBezierPathElement element0,
                                    NSPoint start0,
                                    NSPoint points0[],
                                    NSBezierPathElement element1, 
                                    NSPoint start1,
                                    NSPoint points1[],
                                    NSUInteger num,
                                    NSArray **info)
{
  NSArray *array;
  
  if(NSLineToBezierPathElement == element0 && NSLineToBezierPathElement == element1) {
    NSPoint x;
    BOOL intersect = FLIntersectionLineAndLine(start0, points0[0], start1, points1[0], &x);
    if(intersect) {
      array = [NSArray arrayWithObject:[NSValue valueWithPoint:x]];
    } else {
      array = [NSArray array];
    }
  } else if(NSCurveToBezierPathElement == element0 && NSLineToBezierPathElement == element1) {
    array = FLIntersectionsLineAndCurve(start1, points1[0], start0, points0, num, 0, info);
  } else if(NSLineToBezierPathElement == element0 && NSCurveToBezierPathElement == element1) {
    array = FLIntersectionsLineAndCurve(start0, points0[0], start1, points1, num, 1, info);
  } else if(NSCurveToBezierPathElement == element0 && NSCurveToBezierPathElement == element1) {
    array = FLIntersectionsCurveAndCurve(start0, points0, start1, points1, num, info);
  }
  
  return array;
}

static
inline
NSPoint LineSegmentPoint(CGFloat t, NSPoint a, NSPoint b)
{
  return NSMakePoint((1.0-t)*a.x + t*b.x, (1.0-t)*a.y + t*b.y);
}

void FLSplitCurveFromPoints(CGFloat t, NSPoint p, NSPoint *points, FLCurve **splits)
{
  NSPoint p2, p3, p4, q1, q2, q3, l1, l2, pt;
  
  p2 = points[0];
  p3 = points[1];
  p4 = points[2];

  q1 = LineSegmentPoint(t, p, p2);
  q2 = LineSegmentPoint(t, p2, p3);
  q3 = LineSegmentPoint(t, p3, p4);

  l1 = LineSegmentPoint(t, q1, q2);
  l2 = LineSegmentPoint(t, q2, q3);

  pt = LineSegmentPoint(t, l1, l2);

  *splits = malloc(2*sizeof(FLCurve));
  (*splits)[0].startPoint = p;
  (*splits)[0].controlPoints[0] = q1;
  (*splits)[0].controlPoints[1] = l1;
  (*splits)[0].controlPoints[2] = pt;
  (*splits)[1].startPoint = pt;
  (*splits)[1].controlPoints[0] = l2;
  (*splits)[1].controlPoints[1] = q3;
  (*splits)[1].controlPoints[2] = p4;
}

void FLSplitCurve(double t, FLCurve curve, FLCurve **splits)
{
  FLSplitCurveFromPoints(t, curve.startPoint, curve.controlPoints, splits);
}





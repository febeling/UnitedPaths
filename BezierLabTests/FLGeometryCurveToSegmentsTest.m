//
//  FLFindLineSegmentsForCurve.m
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryCurveToSegmentsTest.h"
#import "FLGeometry.h"

@implementation FLGeometryCurveToSegmentsTest

- (void)setUp
{
  [NSBezierPath setDefaultFlatness:0.6];
  startpoint = NSMakePoint(0,0);
  points[0] = NSMakePoint(0,3); // control 1
  points[1] = NSMakePoint(2,5); // control 2
  points[2] = NSMakePoint(5,5); // end point
  path = [NSBezierPath bezierPath];
  [path moveToPoint:startpoint];
  [path curveToPoint:points[0] controlPoint1:points[1] controlPoint2:points[2]];
}

- (void)tearDown
{
  [NSBezierPath setDefaultFlatness:0.6];
}

- (void)testFindCurvePointForT_0
{
  NSPoint pt = FLCurvePoint(startpoint, points, 0.0);
  STAssertEquals(pt, NSMakePoint(0,0), nil);
}

- (void)testFindCurvePointForT_1
{
  NSPoint pt = FLCurvePoint(startpoint, points, 1.0);
  STAssertEquals(pt, NSMakePoint(5,5), nil);
}

- (void)testFindCurvePointForT_Quarter
{
  NSPoint pt = FLCurvePoint(startpoint, points, 0.25);
  STAssertEquals(pt, NSMakePoint(0.359375, 2.046875), nil);
}

- (void)testFindCurvePointForT_Third
{
  NSPoint pt = FLCurvePoint(startpoint, points, 0.33333);
  STAssertEquals(pt, NSMakePoint(0.62961740746296302, 2.6296074073629634), nil);
}

- (void)testFindCurvePointForT_Ninetynine
{
  NSPoint pt = FLCurvePoint(startpoint, points, 0.99);
  STAssertEquals(pt, NSMakePoint(4.9103009999999996, 4.9994009999999998), nil);
}

- (void)testCurveToSegments
{
  NSUInteger n = 2;
  FLSegment *segments = malloc(n*sizeof(FLSegment));
  FLCurveToSegments(startpoint, points, n, segments);
  
  STAssertEquals(segments[0].start, NSMakePoint(0,0), nil);
  STAssertEquals(segments[0].end, NSMakePoint(1.375,3.625), nil);
  STAssertEquals(segments[0].t0, 0.0, nil);
  STAssertEquals(segments[0].t1, 0.5, nil);
  
  STAssertEquals(segments[1].start, NSMakePoint(1.375,3.625), nil);
  STAssertEquals(segments[1].end, NSMakePoint(5,5), nil);
  STAssertEquals(segments[1].t0, 0.5, nil);
  STAssertEquals(segments[1].t1, 1.0, nil);
  
  free(segments);
}

- (void)testDefaultFlatness
{
  STAssertEquals([path flatness], 0.6, nil);
  [NSBezierPath setDefaultFlatness:10.0];
  STAssertEquals([path flatness], 0.6, nil);
  STAssertEquals([[NSBezierPath bezierPath] flatness], 10.0, nil);
}

- (void)testDefaultFlatnessDeterminesFlatteningSegments
{
  [NSBezierPath setDefaultFlatness:10.0];
  STAssertEquals([[path bezierPathByFlatteningPath] elementCount], 2l, nil);
  [NSBezierPath setDefaultFlatness:0.6];
  STAssertEquals([[path bezierPathByFlatteningPath] elementCount], 5l, nil);
}

@end

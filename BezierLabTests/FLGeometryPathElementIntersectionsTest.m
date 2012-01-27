//
//  FLGeometryPathElementIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 26.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryPathElementIntersectionsTest.h"
#import "FLGeometry.h"

#define D 1.0e-5

@implementation FLGeometryPathElementIntersectionsTest

- (void)testLineSegmentLength
{
  STAssertEqualsWithAccuracy(FLLineSegmentLength(NSMakePoint(1,1), NSMakePoint(2,2)), 1.41421, D, nil);
}

- (void)testPointAreClose
{
  STAssertFalse(FLPointsAreClose(NSMakePoint(0,0), NSMakePoint(1,1)), nil);
  STAssertFalse(FLPointsAreClose(NSMakePoint(1.0,1.0), NSMakePoint(1.1,1.1)), nil);
  STAssertTrue(FLPointsAreClose(NSMakePoint(1.11111111,1.11111111), NSMakePoint(1.11111112,1.11111112)), nil);
}

#pragma mark FLPathElementIntersections

- (void)testLineIntersectsLine
{
  NSPoint s1 = {0, 2};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{3, 2}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSLineToBezierPathElement, s2, points2, 50);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1)]], nil);
}

- (void)testLineIntersectsLine_NoIntersection
{
  NSPoint s1 = {0, 2};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 3};
  NSPoint points2[3] = {{3, 2}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSLineToBezierPathElement, s2, points2, 50);
  
  STAssertEqualObjects(intersections, [NSArray array], nil);
}

- (void)testLineIntersectsCurve_ActuallyStraigthCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{3, 3},{3, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50);
  // Intersection point close to actual (1.5,1.5)
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5006202471811767, 1.5006202471811767)]], nil);
}

- (void)testLineIntersectsCurve_ConvexToTopLeftCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{0, 1},{2, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.125, 1.875)]], nil);
}

- (void)testLineIntersectsCurve_ConvexToBottomRightCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{3, 2},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.875, 1.125)]], nil);
}

- (void)testLineIntersectsCurve_SShapedCurveMetInCenter
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1.5)]], nil);
}

- (void)testLineIntersectsCurve_DiscardDuplicates
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 2);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1.5)]], nil);
}

- (void)testLineIntersectsCurve_FindThreeIntersections
{
  NSPoint s1 = {0.5, 0};
  NSPoint points1[3] = {{2.5, 3}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.57196642028061473, 0.10636256144262296)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.428033579719385, 2.8936374385573771)],
                     nil];
  STAssertEqualObjects(intersections, points, nil);
}

- (void)testCurveIntersectsLine
{
  NSPoint s1 = {0.5, 0};
  NSPoint points1[3] = {{2.5, 3}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  
  NSArray *intersections = FLPathElementIntersections(NSCurveToBezierPathElement, s2, points2,                                                      
                                                      NSLineToBezierPathElement, s1, points1, 50);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.57196642028061473, 0.10636256144262296)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.428033579719385, 2.8936374385573771)], nil];
  STAssertEqualObjects(intersections, points, nil);
}

@end

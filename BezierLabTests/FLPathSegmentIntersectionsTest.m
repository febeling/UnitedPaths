//
//  FLPathSegmentIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 05.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentIntersectionsTest.h"
#import "FLGeometry.h"
#import "FLIntersection.h"
#import "FLPathSegment.h"

#define D 1.0e-3

#define AssertPointsEqualWithAccuracy(P1, P2, D)                  \
  {                                                               \
    NSPoint __p1 = (P1);                                          \
    NSPoint __p2 = (P2);                                          \
    STAssertEqualsWithAccuracy(__p1.x, __p2.x, D, @"x of point"); \
    STAssertEqualsWithAccuracy(__p1.y, __p2.y, D, @"y of point"); \
  }

@implementation FLPathSegmentIntersectionsTest

#pragma mark FLPathElementIntersections Line x Line

- (void)testLineIntersectsLine
{
  NSPoint s1 = {0, 2};
  NSPoint e1 = {3, 0};

  NSPoint s2 = {0, 0};
  NSPoint e2 = {3, 2};

  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:s1 endPoint:e1];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:s2 endPoint:e2];

  [segment1 clipWith:segment2];
  
  FLIntersection *intersection = [[FLIntersection alloc] initWithPoint:NSMakePoint(1.5, 1)];
  
  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:intersection], nil);
  STAssertEqualObjects([segment2 clippings], [NSArray arrayWithObject:intersection], nil);
}

- (void)testLineIntersectsLine_NoIntersection
{
  NSPoint s1 = {0, 2};
  NSPoint e1 = {3, 0};
  
  NSPoint s2 = {0, 3};
  NSPoint e2 = {0, 3};
  
  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:s1 endPoint:e1];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:s2 endPoint:e2];
  
  [segment1 clipWith:segment2];
  
  STAssertEqualObjects([segment1 clippings], [NSArray array], nil);
  STAssertEqualObjects([segment2 clippings], [NSArray array], nil);
}

#pragma mark FLPathElementIntersections Line x Curve

- (void)testLineIntersectsCurve_ActuallyStraigthCurve
{
  NSPoint s1 = {0, 3};
  NSPoint e1 = {3, 0};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{3, 3},{3, 3},{3, 3}};
  
  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:s1 endPoint:e1];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:s2 points:points2];

  [segment1 clipWith:segment2];  
  
  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:[[FLIntersection alloc] initWithPoint:NSMakePoint(1.5006202471811767, 1.5006202471811767)]], nil);

  FLIntersection *intersection = [[segment2 clippings] objectAtIndex:0];
  STAssertEqualsWithAccuracy([intersection time], 0.2064088, D, nil);
  STAssertEquals([intersection point], NSMakePoint(1.5006202471811767, 1.5006202471811767), nil);
}

- (void)testLineIntersectsCurve_ConvexToTopLeftCurve
{
  NSPoint points2[3] = {{0, 1},{2, 3},{3, 3}};

  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,3) endPoint:NSMakePoint(3,0)];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];

  [segment1 clipWith:segment2];
  
  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:[[FLIntersection alloc] initWithPoint:NSMakePoint(1.125, 1.875)]], nil);

  FLIntersection *intersection = [[segment2 clippings] objectAtIndex:0];
  STAssertEqualsWithAccuracy([intersection time], 0.5, D, nil);
  STAssertEquals([intersection point], NSMakePoint(1.125, 1.875), nil);
}

- (void)testLineIntersectsCurve_ConvexToBottomRightCurve
{
  NSPoint points2[3] = {{1, 0},{3, 2},{3, 3}};

  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,3) endPoint:NSMakePoint(3,0)];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];
  
  [segment1 clipWith:segment2];
  
  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:[[FLIntersection alloc] initWithPoint:NSMakePoint(1.875, 1.125)]], nil);

  FLIntersection *intersection = [[segment2 clippings] objectAtIndex:0];
  STAssertEqualsWithAccuracy([intersection time], 0.5, D, nil);
  STAssertEquals([intersection point], NSMakePoint(1.875, 1.125), nil);
}

- (void)testLineIntersectsCurve_SShapedCurveMetInCenter
{
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};

  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,3) endPoint:NSMakePoint(3,0)];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];

  [segment1 clipWith:segment2];
  
  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:[[FLIntersection alloc] initWithPoint:NSMakePoint(1.5, 1.5)]], nil);
  
  FLIntersection *intersection = [[segment2 clippings] objectAtIndex:0];
  STAssertEqualsWithAccuracy([intersection time], 0.5, D, nil);
  STAssertEquals([intersection point], NSMakePoint(1.5, 1.5), nil);
}

- (void)testLineIntersectsCurve_DiscardDuplicatePoints
{
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};
  
  FLPathSegment *segment1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,3) endPoint:NSMakePoint(3,0)];
  FLPathSegment *segment2 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];
  
  [segment1 clipWith:segment2];

  STAssertEqualObjects([segment1 clippings], [NSArray arrayWithObject:[[FLIntersection alloc] initWithPoint:NSMakePoint(1.5, 1.5)]], nil);
  
  FLIntersection *intersection = [[segment2 clippings] objectAtIndex:0];
  STAssertEqualsWithAccuracy([intersection time], 0.5, D, nil);
  STAssertEquals([intersection point], NSMakePoint(1.5, 1.5), nil);
}

- (void)testLineIntersectsCurve_FindThreeIntersections
{
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  
  FLPathSegment *lineSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0.5,0) endPoint:NSMakePoint(2.5,3)];
  FLPathSegment *curveSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];
  
  [lineSegment clipWith:curveSegment];
  
  {  
    FLIntersection *intersection0 = [[curveSegment clippings] objectAtIndex:0];
    STAssertEquals([intersection0 point], NSMakePoint(0.57196642028061473, 0.10636256144262296), nil);
    STAssertEqualsWithAccuracy([intersection0 time], 0.1130, D, nil);
    
    FLIntersection *intersection1 = [[curveSegment clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curveSegment clippings] objectAtIndex:2];
    STAssertEquals([intersection2 point], NSMakePoint(2.428033579719385, 2.8936374385573771), nil);
    STAssertEqualsWithAccuracy([intersection2 time], 0.8869, D, nil);
  }
  
  {
    FLIntersection *intersection0 = [[lineSegment clippings] objectAtIndex:0];
    STAssertEquals([intersection0 point], NSMakePoint(0.57196642028061473, 0.10636256144262296), nil);
    STAssertEqualsWithAccuracy([intersection0 time], -1.0, D, nil);
    
    FLIntersection *intersection1 = [[lineSegment clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], -1.0, D, nil);
    
    FLIntersection *intersection2 = [[lineSegment clippings] objectAtIndex:2];
    STAssertEquals([intersection2 point], NSMakePoint(2.428033579719385, 2.8936374385573771), nil);
    STAssertEqualsWithAccuracy([intersection2 time], -1.0, D, nil);
  }
}

- (void)testCurveIntersectsLine_ReverseParameterOrder
{
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  
  FLPathSegment *lineSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0.5,0) endPoint:NSMakePoint(2.5,3)];
  FLPathSegment *curveSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];

  [curveSegment clipWith:lineSegment];
  
  {  
    FLIntersection *intersection0 = [[curveSegment clippings] objectAtIndex:0];
    STAssertEquals([intersection0 point], NSMakePoint(0.57196642028061473, 0.10636256144262296), nil);
    STAssertEqualsWithAccuracy([intersection0 time], 0.1130, D, nil);
    
    FLIntersection *intersection1 = [[curveSegment clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curveSegment clippings] objectAtIndex:2];
    STAssertEquals([intersection2 point], NSMakePoint(2.428033579719385, 2.8936374385573771), nil);
    STAssertEqualsWithAccuracy([intersection2 time], 0.8869, D, nil);
  }
  
  {
    FLIntersection *intersection0 = [[lineSegment clippings] objectAtIndex:0];
    STAssertEquals([intersection0 point], NSMakePoint(0.57196642028061473, 0.10636256144262296), nil);
    STAssertEqualsWithAccuracy([intersection0 time], -1.0, D, nil);
    
    FLIntersection *intersection1 = [[lineSegment clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], -1.0, D, nil);
    
    FLIntersection *intersection2 = [[lineSegment clippings] objectAtIndex:2];
    STAssertEquals([intersection2 point], NSMakePoint(2.428033579719385, 2.8936374385573771), nil);
    STAssertEqualsWithAccuracy([intersection2 time], -1.0, D, nil);
  }
}

#pragma mark FLPathElementIntersections Curve x Curve

- (void)testCurveIntersectsCurve
{
  NSPoint points1[3] = {{3, 0.5},{0, 2.5},{3, 2.5}};
  NSPoint points2[3] = {{0.5, 3},{2.5, 0},{2.5, 3}};
  
  FLPathSegment *curve0 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0.5) points:points1];
  FLPathSegment *curve1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0.5,0) points:points2];
  
  [curve0 clipWith:curve1];
  
  {  
    FLIntersection *intersection0 = [[curve0 clippings] objectAtIndex:0];
    AssertPointsEqualWithAccuracy([intersection0 point], NSMakePoint(0.52788036446534115, 0.5259620130065159), D);
    STAssertEqualsWithAccuracy([intersection0 time], 0.0669, D, nil);
    
    FLIntersection *intersection1 = [[curve0 clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curve0 clippings] objectAtIndex:2];
    AssertPointsEqualWithAccuracy([intersection2 point], NSMakePoint(2.4721, 2.4742), D);
    STAssertEqualsWithAccuracy([intersection2 time], 0.9330, D, nil);
  }
  
  {
    FLIntersection *intersection0 = [[curve1 clippings] objectAtIndex:0];
    AssertPointsEqualWithAccuracy([intersection0 point], NSMakePoint(0.5278, 0.5259), D);
    STAssertEqualsWithAccuracy([intersection0 time], 0.0669, D, nil);
    
    FLIntersection *intersection1 = [[curve1 clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curve1 clippings] objectAtIndex:2];
    AssertPointsEqualWithAccuracy([intersection2 point], NSMakePoint(2.4721, 2.4742), D);
    STAssertEqualsWithAccuracy([intersection2 time], 0.9330, D, nil);
  }
}

- (void)testCurveIntersectsCurve_Asymmetrical
{
  NSPoint points1[3] = {{3, 2.5},{0,0.5},{3,0.5}};
  NSPoint points2[3] = {{0.5,0},{2.5,3},{2.5,0}};
  
  FLPathSegment *curve0 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,2.5) points:points1];
  FLPathSegment *curve1 = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0.5,3) points:points2];
  
  [curve0 clipWith:curve1];
  
  {  
    FLIntersection *intersection0 = [[curve0 clippings] objectAtIndex:0];
    AssertPointsEqualWithAccuracy([intersection0 point], NSMakePoint(0.5278, 2.4742), D);
    STAssertEqualsWithAccuracy([intersection0 time], 0.0669, D, nil);
    
    FLIntersection *intersection1 = [[curve0 clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curve0 clippings] objectAtIndex:2];
    AssertPointsEqualWithAccuracy([intersection2 point], NSMakePoint(2.4721, 0.5257), D);
    STAssertEqualsWithAccuracy([intersection2 time], 0.9330, D, nil);
  }
  
  {
    FLIntersection *intersection0 = [[curve1 clippings] objectAtIndex:0];
    AssertPointsEqualWithAccuracy([intersection0 point], NSMakePoint(0.5278, 2.4742), D);
    STAssertEqualsWithAccuracy([intersection0 time], 0.0669, D, nil);
    
    FLIntersection *intersection1 = [[curve1 clippings] objectAtIndex:1];
    STAssertEquals([intersection1 point], NSMakePoint(1.5, 1.5), nil);
    STAssertEqualsWithAccuracy([intersection1 time], 0.5, D, nil);
    
    FLIntersection *intersection2 = [[curve1 clippings] objectAtIndex:2];
    AssertPointsEqualWithAccuracy([intersection2 point], NSMakePoint(2.4721, 0.5257), D);
    STAssertEqualsWithAccuracy([intersection2 time], 0.9330, D, nil);
  }
}

@end

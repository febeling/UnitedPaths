//
//  FLGeometryPathElementIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 26.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryPathElementIntersectionsTest.h"
#import "FLGeometry.h"

#define D 1.0e-4

static
NSDictionary *makeIntersection(CGFloat t)
{
  return [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:t] forKey:@"t"];
}

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

#pragma mark FLPathElementIntersections Line x Line

- (void)testLineIntersectsLine
{
  NSPoint s1 = {0, 2};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{3, 2}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSLineToBezierPathElement, s2, points2, 50, &info);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1)]], nil);
  STAssertNil(info, nil);
}

- (void)testLineIntersectsLine_NoIntersection
{
  NSPoint s1 = {0, 2};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 3};
  NSPoint points2[3] = {{3, 2}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSLineToBezierPathElement, s2, points2, 50, &info);
  
  STAssertEqualObjects(intersections, [NSArray array], nil);
  STAssertNil(info, nil);
}

#pragma mark FLPathElementIntersections Line x Curve

- (void)testLineIntersectsCurve_ActuallyStraigthCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{3, 3},{3, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50, &info);

  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5006202471811767, 1.5006202471811767)]], nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.2064, D, nil);
}

- (void)testLineIntersectsCurve_ConvexToTopLeftCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{0, 1},{2, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,
                                                      NSCurveToBezierPathElement, s2, points2, 50, &info);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.125, 1.875)]], nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
}

- (void)testLineIntersectsCurve_ConvexToBottomRightCurve
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{3, 2},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50, &info);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.875, 1.125)]], nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
}

- (void)testLineIntersectsCurve_SShapedCurveMetInCenter
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50, &info);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1.5)]], nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
}

- (void)testLineIntersectsCurve_DiscardDuplicates
{
  NSPoint s1 = {0, 3};
  NSPoint points1[3] = {{3, 0}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{1, 0},{2, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 2, &info);
  
  STAssertEqualObjects(intersections, [NSArray arrayWithObject:[NSValue valueWithPoint:NSMakePoint(1.5, 1.5)]], nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
}

- (void)testLineIntersectsCurve_FindThreeIntersections
{
  NSPoint s1 = {0.5, 0};
  NSPoint points1[3] = {{2.5, 3}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSLineToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 50, &info);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.57196642028061473, 0.10636256144262296)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.428033579719385, 2.8936374385573771)],
                     nil];
  STAssertEqualObjects(intersections, points, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.1130, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t1"] doubleValue], 0.8869, D, nil);
}

- (void)testCurveIntersectsLine_ReverseParameterOrder
{
  NSPoint s1 = {0.5, 0};
  NSPoint points1[3] = {{2.5, 3}};
  NSPoint s2 = {0, 0};
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSCurveToBezierPathElement, s2, points2,                                                      
                                                      NSLineToBezierPathElement, s1, points1, 50, &info);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.57196642028061473, 0.10636256144262296)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.428033579719385, 2.8936374385573771)], nil];
  STAssertEqualObjects(intersections, points, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t0"] doubleValue], 0.1130, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t0"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t0"] doubleValue], 0.8869, D, nil);
}

#pragma mark FLPathElementIntersections Curve x Curve

- (void)testCurveIntersectsCurve
{
  // Both curves rising with larger x
  NSPoint s1 = {0, 0.5};
  NSPoint points1[3] = {{3, 0.5},{0, 2.5},{3, 2.5}};
  NSPoint s2 = {0.5, 0};
  NSPoint points2[3] = {{0.5, 3},{2.5, 0},{2.5, 3}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSCurveToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 500, &info);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.52574480100680365, 0.52572401863277296)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.4742551989931956, 2.4742759813672266)], nil];
  STAssertEqualObjects(intersections, points, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t0"] doubleValue], 0.0669, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t0"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t0"] doubleValue], 0.9330, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.0669, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t1"] doubleValue], 0.9330, D, nil);
}

- (void)testCurveIntersectsCurve_Other
{
  // Both curves falling with larger x
  NSPoint s1 = {0, 2.5};
  NSPoint points1[3] = {{3, 2.5},{0,0.5},{3,0.5}};
  NSPoint s2 = {0.5, 3};
  NSPoint points2[3] = {{0.5,0},{2.5,3},{2.5,0}};
  NSArray *info = nil;
  
  NSArray *intersections = FLPathElementIntersections(NSCurveToBezierPathElement, s1, points1,                                                      
                                                      NSCurveToBezierPathElement, s2, points2, 500, &info);
  
  NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithPoint:NSMakePoint(0.52574480100680343, 2.474275981367227)],
                     [NSValue valueWithPoint:NSMakePoint(1.5, 1.5)],
                     [NSValue valueWithPoint:NSMakePoint(2.4742551989931965, 0.52572401863277296)], nil];
  STAssertEqualObjects(intersections, points, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t0"] doubleValue], 0.0669, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t0"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t0"] doubleValue], 0.9330, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t1"] doubleValue], 0.0669, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:1] objectForKey:@"t1"] doubleValue], 0.5, D, nil);
  STAssertEqualsWithAccuracy([[[info objectAtIndex:2] objectForKey:@"t1"] doubleValue], 0.9330, D, nil);
}

@end

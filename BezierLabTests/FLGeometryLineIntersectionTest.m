//
//  FLGeometryTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FLGeometryLineIntersectionTest.h"
#import "FLGeometry.h"

@implementation FLGeometryLineIntersectionTest

- (void)setUp
{
  x = NSZeroPoint;
}

- (void)testLineIntersection_PlainIntersection
{
  NSPoint p1 = {0,0};
  NSPoint p2 = {2,2};
  NSPoint p3 = {0,2};
  NSPoint p4 = {2,0};
  
  STAssertTrue(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
  STAssertEquals(x, NSMakePoint(1,1), nil);
}

- (void)testLineIntersection_Miss
{
  NSPoint p1 = {0,2};
  NSPoint p2 = {2,0};
  NSPoint p3 = {2,1};
  NSPoint p4 = {2,3};
  
  STAssertFalse(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
}

- (void)testLineIntersection_AnotherMiss
{
  NSPoint p1 = {0,1};
  NSPoint p2 = {1,2};
  NSPoint p3 = {1,1};
  NSPoint p4 = {2,0};
  
  STAssertFalse(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
}

- (void)testLineIntersection_AnotherPlainIntersection
{
  NSPoint p1 = {0,1};
  NSPoint p2 = {2,0};
  NSPoint p3 = {1,0};
  NSPoint p4 = {1,2};
  
  STAssertTrue(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
  STAssertEquals(x, NSMakePoint(1,0.5), nil);
}

- (void)testLineIntersection_Parallels
{
  NSPoint p1 = {1,1};
  NSPoint p2 = {1,3};
  NSPoint p3 = {2,0};
  NSPoint p4 = {2,2};
  
  STAssertFalse(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
}

- (void)testLineIntersection_SameDifferentSegments
{
  NSPoint p1 = {2,0};
  NSPoint p2 = {2,1};
  NSPoint p3 = {2,2};
  NSPoint p4 = {2,3};
  
  STAssertFalse(FLLineSegmentIntersection(p1,p2,p3,p4, &x), nil);
}

@end

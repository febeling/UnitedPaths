//
//  FLGeometryHelpersTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 05.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryHelpersTest.h"
#import "FLGeometry.h"

#define D 1.0e-4

@implementation FLGeometryHelpersTest

- (void)testLinePointOnSegment_AllowCloseYValues
{
  NSPoint p1 = {330,250};
  NSPoint p2 = {170,250};
  NSPoint x = {275.38094238792877, 249.99999999999997};
  
  STAssertEquals(FLLinePointOnSegment(p1,p2,x), YES, nil);
}

- (void)testLinePointOnSegment_AllowCloseXValues
{
  NSPoint p1 = {330,250};
  NSPoint p2 = {330,220};
  NSPoint x = {330.00000000000004, 241.7};
  
  STAssertEquals(FLLinePointOnSegment(p1,p2,x), YES, nil);
}

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

- (void)testTimeIsClose
{
  STAssertFalse(FLFloatIsClose(0.999, 1.0), nil);
  STAssertTrue(FLFloatIsClose(0.99999, 1.0), nil);
  
  STAssertFalse(FLFloatIsClose(0.0001, 0.0), nil);
  STAssertTrue(FLFloatIsClose(0.000001, 0.0), nil);
}

- (void)testTimeIsCloseBeginningOrEnd
{
  STAssertFalse(FLTimeIsCloseBeginningOrEnd(0.999), nil);
  STAssertTrue(FLTimeIsCloseBeginningOrEnd(0.99999), nil);
  
  STAssertFalse(FLTimeIsCloseBeginningOrEnd(0.0001), nil);
  STAssertTrue(FLTimeIsCloseBeginningOrEnd(0.000001), nil);
}

@end

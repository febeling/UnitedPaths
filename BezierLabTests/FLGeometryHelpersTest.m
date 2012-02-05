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

@end

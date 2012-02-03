//
//  FLGeometryCurveSplit.m
//  BezierLab
//
//  Created by Florian Ebeling on 27.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryCurveSplit.h"

@implementation FLGeometryCurveSplit

- (void)setUp
{
  curve = (FLCurve) {
    {0, 0}, 
    {{1, 0},{2, 3},{3, 3}}
  };
}

- (void)testSplitCurve_Half
{
  FLCurve *splits;
  
  FLSplitCurve(0.5, curve, &splits);
  
  STAssertEquals(splits[0].startPoint, NSMakePoint(0, 0), nil);
  STAssertEquals(splits[0].controlPoints[0], NSMakePoint(0.5, 0), nil);
  STAssertEquals(splits[0].controlPoints[1], NSMakePoint(1, 0.75), nil);
  STAssertEquals(splits[0].controlPoints[2], NSMakePoint(1.5, 1.5), nil);
  STAssertEquals(splits[1].startPoint, NSMakePoint(1.5, 1.5), nil);
  STAssertEquals(splits[1].controlPoints[0], NSMakePoint(2, 2.25), nil);
  STAssertEquals(splits[1].controlPoints[1], NSMakePoint(2.5, 3), nil);
  STAssertEquals(splits[1].controlPoints[2], NSMakePoint(3, 3), nil);
  
  free(splits);
}

- (void)testSplitCurve_ThreeTenth
{
  FLCurve *splits;
  
  FLSplitCurve(0.4, curve, &splits);
  
  STAssertEquals(splits[0].startPoint, NSMakePoint(0, 0), nil);
  STAssertEquals(splits[0].controlPoints[0], NSMakePoint(0.4, 0), nil);
  STAssertEquals(splits[0].controlPoints[1], NSMakePoint(0.79999999999999993, 0.48000000000000009), nil);
  STAssertEquals(splits[0].controlPoints[2], NSMakePoint(1.2000000000000002, 1.0560000000000003), nil);
  STAssertEquals(splits[1].startPoint, NSMakePoint(1.2000000000000002, 1.0560000000000003), nil);
  STAssertEquals(splits[1].controlPoints[0], NSMakePoint(1.8000000000000003, 1.9200000000000004), nil);
  STAssertEquals(splits[1].controlPoints[1], NSMakePoint(2.4000000000000004, 3), nil);
  STAssertEquals(splits[1].controlPoints[2], NSMakePoint(3, 3), nil);

  free(splits);
}

@end

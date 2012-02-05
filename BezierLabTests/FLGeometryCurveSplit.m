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

- (void)testSplitCurve_FourTenth
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

- (void)testSplitCurve_PartOfOval
{
  FLCurve arc = (FLCurve) {
    {1.5857864376269051, 4.4142135623730949},
    {{0.80473785412436527, 3.6331649788705551},
      {0.80473785412436483, 2.3668350211294449},
      {1.5857864376269046, 1.5857864376269051}}
  };
  FLCurve *splits;
  
  FLSplitCurve(0.1621845688619874, arc, &splits);
  
  STAssertEquals(splits[0].startPoint,       NSMakePoint(1.5857864376269051, 4.4142135623730949), nil);
  STAssertEquals(splits[0].controlPoints[0], NSMakePoint(1.4591124098512798, 4.2875395345974692), nil);
  STAssertEquals(splits[0].controlPoints[1], NSMakePoint(1.3529829546564558, 4.1481007459276542), nil);
  STAssertEquals(splits[0].controlPoints[2], NSMakePoint(1.2673980720424327, 4.000037690848151), nil);
  STAssertEquals(splits[1].startPoint,       NSMakePoint(1.2673980720424327, 4.000037690848151), nil);
  STAssertEquals(splits[1].controlPoints[0], NSMakePoint(0.82528242670516638, 3.2351713832982232), nil);
  STAssertEquals(splits[1].controlPoints[1], NSMakePoint(0.93141188189999014, 2.2401609933538196), nil);
  STAssertEquals(splits[1].controlPoints[2], NSMakePoint(1.5857864376269046, 1.5857864376269051), nil);
  
  free(splits);
}

@end

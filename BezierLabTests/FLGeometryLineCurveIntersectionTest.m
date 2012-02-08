//
//  FLGeometryLineCurveIntersection.m
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLGeometryLineCurveIntersectionTest.h"
#import "FLGeometry.h"
#import "TestHelper.h"

@implementation FLGeometryLineCurveIntersectionTest

- (void)testParameterInfoIsOptional
{
  NSPoint lineStart = NSMakePoint(0,0);
  NSPoint lineEnd = NSMakePoint(9,9);
  NSPoint curveStart = NSMakePoint(5,0);
  NSPoint curvePoints[3] = {{10,5},{-5,5},{-3,9}};
  
  STAssertNoThrow(FLIntersectionsLineAndCurve(lineStart, lineEnd, curveStart, curvePoints, 50, 0, nil), nil);
}

- (void)testIntersectionsLineAndCurve
{
  NSPoint lineStart = NSMakePoint(0,0);
  NSPoint lineEnd = NSMakePoint(9,9);
  NSPoint curveStart = NSMakePoint(5,0);
  NSPoint curvePoints[3] = {{10,5},{-5,5},{-3,9}};
  
  NSArray *info;
  
  NSArray *intersectionPoints = FLIntersectionsLineAndCurve(lineStart, lineEnd, curveStart, curvePoints, 50, 0, &info);

  STAssertEqualsWithAccuracy([[[info objectAtIndex:0] objectForKey:@"t0"] doubleValue], 0.3817, 1.0e-4, nil);
  AssertPointsEqualWithAccuracy([[intersectionPoints objectAtIndex:0] pointValue], NSMakePoint(4.0411,4.0407), 1.0e-4);
}

@end

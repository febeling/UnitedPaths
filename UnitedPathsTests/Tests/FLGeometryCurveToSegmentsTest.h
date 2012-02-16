//
//  FLFindLineSegmentsForCurve.h
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface FLGeometryCurveToSegmentsTest : SenTestCase
{
  NSPoint startpoint;
  NSPoint points[3];
  NSBezierPath *path;
}
@end

//
//  FLPathSegmentBezierPathWithSegmentsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentBezierPathWithSegmentsTest.h"
#import "TestHelper.h"
#import "FLPathSegment.h"
#import "NSBezierPath+UnitedPathsInternal.h"

@implementation FLPathSegmentBezierPathWithSegmentsTest

- (void)testBezierPathWithSegments_EmptyPath
{
  NSBezierPath *path = [NSBezierPath bezierPathWithSegments:[NSArray array]];
  
  STAssertTrue([path isKindOfClass:[NSBezierPath class]], nil);
}

- (void)testBezierPathWithSegments
{
  NSBezierPath *rect = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,3,2)];
  NSArray *segments = [rect segments];
  NSBezierPath *newRect = [NSBezierPath bezierPathWithSegments:segments];

  STAssertTrue([newRect isEqualToBezierPath:rect], nil);
}

- (void)testBezierPathWithSegments_NotClosed
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  [path lineToPoint:NSMakePoint(4,1)];
  [path lineToPoint:NSMakePoint(4,4)];
  
  NSArray *segments = [path segments];
  NSBezierPath *newPath = [NSBezierPath bezierPathWithSegments:segments];
  
  STAssertTrue([newPath isEqualToBezierPath:path], nil);
}

- (void)testBezierPathWithSegments_AddsClosePathForLine
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  [path lineToPoint:NSMakePoint(4,1)];
  [path lineToPoint:NSMakePoint(4,4)];
  [path lineToPoint:NSMakePoint(1,1)];
  
  NSArray *segments = [path segments];
  NSBezierPath *newPath = [NSBezierPath bezierPathWithSegments:segments];
  
  STAssertEquals([newPath elementCount], 5l, nil);
  STAssertEquals([newPath elementAtIndex:3], (NSBezierPathElement)NSClosePathBezierPathElement, nil);
}

- (void)testBezierPathWithSegments_DontCloseWhenTerminalCurveSegment
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  [path lineToPoint:NSMakePoint(4,1)];
  [path lineToPoint:NSMakePoint(4,4)];
  [path curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(3,4) controlPoint2:NSMakePoint(1,2)];
  
  NSArray *segments = [path segments];
  NSBezierPath *newPath = [NSBezierPath bezierPathWithSegments:segments];
  
  STAssertEquals([newPath elementCount], 4l, nil);
  STAssertEquals([newPath elementAtIndex:3], (NSBezierPathElement)NSCurveToBezierPathElement, nil);
}

@end

//
//  FLPathSegmentBezierPathWithSegmentsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentBezierPathWithSegmentsTest.h"
#import "TestHelper.h"
#import "NSBezierPath+BezierLabs.h"

@implementation FLPathSegmentBezierPathWithSegmentsTest

- (void)testBezierPathWithSegments_EmptyPath
{
  NSBezierPath *path = [FLPathSegment bezierPathWithSegments:[NSArray array]];
  
  STAssertTrue([path isKindOfClass:[NSBezierPath class]], nil);
}

- (void)testBezierPathWithSegments
{
  NSBezierPath *rect = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,3,2)];
  NSArray *segments = [rect segments];
  NSBezierPath *newRect = [FLPathSegment bezierPathWithSegments:segments];

  STAssertTrue([newRect isEqualToBezierPath:rect], nil);
}

- (void)testBezierPathWithSegments_NotClosed
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  [path lineToPoint:NSMakePoint(4,1)];
  [path lineToPoint:NSMakePoint(4,4)];
  
  NSArray *segments = [path segments];
  NSBezierPath *newPath = [FLPathSegment bezierPathWithSegments:segments];
  
  STAssertTrue([newPath isEqualToBezierPath:path], nil);
}

@end

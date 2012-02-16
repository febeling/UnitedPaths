//
//  NSBezierPathEquality.m
//  BezierLab
//
//  Created by Florian Ebeling on 08.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPathEqualityTest.h"
#import "NSBezierPath+BezierLabs.h"

@implementation NSBezierPathEqualityTest

- (void)testIsEqualToBezierPath
{
  NSBezierPath *onePath = [NSBezierPath bezierPath];
  [onePath moveToPoint:NSMakePoint(1,1)];
  [onePath lineToPoint:NSMakePoint(3,0)];
  [onePath curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,5)];
  
  NSBezierPath *otherPath = [NSBezierPath bezierPath];
  [otherPath moveToPoint:NSMakePoint(1,1)];
  [otherPath lineToPoint:NSMakePoint(3,0)];
  [otherPath curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,5)];
  
  STAssertTrue([onePath isEqualToBezierPath:otherPath], nil);
}

- (void)testIsEqualToBezierPath_DifferentMove
{
  NSBezierPath *onePath = [NSBezierPath bezierPath];
  [onePath moveToPoint:NSMakePoint(1,1)];
  
  NSBezierPath *otherPath = [NSBezierPath bezierPath];
  [otherPath moveToPoint:NSMakePoint(9,9)];
  
  STAssertFalse([onePath isEqualToBezierPath:otherPath], nil);
}

- (void)testIsEqualToBezierPath_DifferentCurve
{
  NSBezierPath *onePath = [NSBezierPath bezierPath];
  [onePath moveToPoint:NSMakePoint(1,1)];
  [onePath lineToPoint:NSMakePoint(3,0)];
  [onePath curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,9)];
  
  NSBezierPath *otherPath = [NSBezierPath bezierPath];
  [otherPath moveToPoint:NSMakePoint(1,1)];
  [otherPath lineToPoint:NSMakePoint(3,0)];
  [otherPath curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,5)];
  
  STAssertFalse([onePath isEqualToBezierPath:otherPath], nil);
}

- (void)testIsEqualToBezierPath_DifferentLine
{
  NSBezierPath *onePath = [NSBezierPath bezierPath];
  [onePath moveToPoint:NSMakePoint(1,1)];
  [onePath lineToPoint:NSMakePoint(3,9)];
  
  NSBezierPath *otherPath = [NSBezierPath bezierPath];
  [otherPath moveToPoint:NSMakePoint(1,1)];
  [otherPath lineToPoint:NSMakePoint(3,0)];
  
  STAssertFalse([onePath isEqualToBezierPath:otherPath], nil);
}

- (void)testIsEqualToBezierPath_DifferentInThatOneIsClosed
{
  NSBezierPath *onePath = [NSBezierPath bezierPath];
  [onePath moveToPoint:NSMakePoint(1,1)];
  [onePath closePath];
  
  NSBezierPath *otherPath = [NSBezierPath bezierPath];
  [otherPath moveToPoint:NSMakePoint(1,1)];
  [otherPath curveToPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,5)];
  
  STAssertFalse([onePath isEqualToBezierPath:otherPath], nil);
}

@end

//
//  NSBezierPathAppendPathWithElement.m
//  BezierLab
//
//  Created by Florian Ebeling on 08.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPathAppendPathWithElementTest.h"
#import "NSBezierPath+UnitedPaths.h"
#import "NSBezierPath+UnitedPathsInternal.h"


@implementation NSBezierPathAppendPathWithElementTest

- (void)setUp
{
  path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
}

- (void)testAppendBezierPathWithElement_Curve
{
  NSPoint points[3] = {{1,0},{0,1},{1,1}};
  NSPoint result[3];
  [path appendElement:NSCurveToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSCurveToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
  STAssertEquals(points[1], result[1], nil);
  STAssertEquals(points[2], result[2], nil);
}

- (void)testAppendBezierPathWithElement_Line
{
  NSPoint points[1] = {{1,0}};
  NSPoint result[1];
  [path appendElement:NSLineToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSLineToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
}

- (void)testAppendBezierPathWithElement_Move
{
  NSPoint points[1] = {{3,3}};
  NSPoint result[1];
  [path appendElement:NSMoveToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementCount], 1L, @"the moveTo follows another moveTo, so replaces it");
  STAssertEquals([path elementAtIndex:0 associatedPoints:result], (NSBezierPathElement)NSMoveToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
}

- (void)testAppendBezierPathWithElement_Close
{
  NSPoint result[3];
  [path appendElement:NSClosePathBezierPathElement associatedPoints:NULL];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSClosePathBezierPathElement, nil);
}

@end

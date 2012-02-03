//
//  BezierLabTests.m
//  BezierLabTests
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "BezierLabTests.h"

@implementation BezierLabTests

- (void)setUp
{
  path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  rectPath = [NSBezierPath bezierPathWithRect:NSMakeRect(0,0,40,20)];
  roundedRectPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0,0,40,20) xRadius:5 yRadius:5];
  translation = [NSAffineTransform transform];
  [translation translateXBy:20 yBy:10];
}

/*
- (void)testUnionRectAndAnotherRect
{
  NSBezierPath *anotherRectPath = [rectPath copy];
  [anotherRectPath transformUsingAffineTransform:translation];
  NSBezierPath *newPath;
  newPath = [rectPath bezierPathByUnionWith:anotherRectPath];
  
  STAssertNotNil(newPath, nil);
  STAssertEquals([newPath elementCount], 17L, nil);// == [rectPath elementCount], nil);
  NSLog(@"newPath: %@", newPath);
}
 
- (void)testUnionRectAndRoundedRect
{
  NSBezierPath *newPath = [rectPath bezierPathByUnionWith:roundedRectPath];
  
  STAssertNotNil(newPath, nil);
}
 */

- (void)testCreatingPathFristNeedsAMoveToCommand
{
  STAssertThrows([[NSBezierPath bezierPath] lineToPoint:NSMakePoint(1,1)], nil);
  STAssertThrows([[NSBezierPath bezierPath] curveToPoint:NSMakePoint(1,1)
                                           controlPoint1:NSMakePoint(1,2)
                                           controlPoint2:NSMakePoint(2,2)], nil);
  STAssertNoThrow([[NSBezierPath bezierPath] moveToPoint:NSMakePoint(1,1)], nil);
}

- (void)testAppendBezierPathWithElement_Curve
{
  NSPoint points[3] = {{1,0},{0,1},{1,1}};
  NSPoint result[3];
  [path appendBezierPathWithElement:NSCurveToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSCurveToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
  STAssertEquals(points[1], result[1], nil);
  STAssertEquals(points[2], result[2], nil);
}

- (void)testAppendBezierPathWithElement_Line
{
  NSPoint points[1] = {{1,0}};
  NSPoint result[1];
  [path appendBezierPathWithElement:NSLineToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSLineToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
}

- (void)testAppendBezierPathWithElement_Move
{
  NSPoint points[1] = {{3,3}};
  NSPoint result[1];
  [path appendBezierPathWithElement:NSMoveToBezierPathElement associatedPoints:points];
  
  STAssertEquals([path elementCount], 1L, @"the moveTo follows another moveTo, so replaces it");
  STAssertEquals([path elementAtIndex:0 associatedPoints:result], (NSBezierPathElement)NSMoveToBezierPathElement, nil);
  STAssertEquals(points[0], result[0], nil);
}

- (void)testAppendBezierPathWithElement_Close
{
  NSPoint result[3];
  [path appendBezierPathWithElement:NSClosePathBezierPathElement associatedPoints:NULL];
  
  STAssertEquals([path elementAtIndex:1 associatedPoints:result], (NSBezierPathElement)NSClosePathBezierPathElement, nil);
}

@end

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

- (void)testUnionRectAndAnotherRect_ToTheTopRight
{
  NSBezierPath *anotherRectPath = [rectPath copy];
  [anotherRectPath transformUsingAffineTransform:translation];

  STAssertNoThrow([rectPath unionWithBezierPath:anotherRectPath], nil);  
}

- (void)testUnionRectAndAnotherRect_TShapedUnion
{
  NSBezierPath *top = [NSBezierPath bezierPathWithRect:NSMakeRect(0,10,30,20)];
  NSBezierPath *trunk = [NSBezierPath bezierPathWithRect:NSMakeRect(10,0,10,20)];

  STAssertNoThrow([trunk unionWithBezierPath:top], nil);

//  NSArray *segments = [NSArray arrayWithObjects:
//                       @"<FLPathLineSegment startPoint: {10, 0}, endPoint: {20, 0}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {20, 0}, endPoint: {20, 10}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {20, 10}, endPoint: {30, 10}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {30, 10}, endPoint: {30, 30}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {30, 30}, endPoint: {0, 30}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {0, 30}, endPoint: {0, 10}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {0, 10}, endPoint: {10, 10}, keep: YES>",
//                       @"<FLPathLineSegment startPoint: {10, 10}, endPoint: {10, 0}, keep: YES>", nil];
//  
//  STAssertEqualObjects([unionSegments valueForKey:@"description"], segments, nil);
}

- (void)testUnionRectAndRoundedRect
{
  [roundedRectPath transformUsingAffineTransform:translation];
  
  STAssertNoThrow([rectPath unionWithBezierPath:roundedRectPath], nil);
}

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

#pragma mark isEqualToBezierPath:

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

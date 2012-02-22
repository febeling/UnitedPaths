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

  NSArray *unionSegments = [trunk unionWithBezierPath:top];
  
  NSArray *segments = [NSArray arrayWithObjects:
                       @"<FLPathLineSegment startPoint: {10, 0}, endPoint: {20, 0}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {20, 0}, endPoint: {20, 10}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {20, 10}, endPoint: {30, 10}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {30, 10}, endPoint: {30, 30}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {30, 30}, endPoint: {0, 30}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {0, 30}, endPoint: {0, 10}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {0, 10}, endPoint: {10, 10}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {10, 10}, endPoint: {10, 0}, keep: YES>", nil];
  
  STAssertEqualObjects([unionSegments valueForKey:@"description"], segments, nil);
}

- (void)testUnionRectAndRoundedRect_NoThrow
{
  [roundedRectPath transformUsingAffineTransform:translation];
  
  STAssertNoThrow([rectPath unionWithBezierPath:roundedRectPath], nil);
}

- (void)testUnionRectAndRoundedRect
{
  [roundedRectPath transformUsingAffineTransform:translation];
  
  NSBezierPath *unionPath = [rectPath bezierPathByUnionWith:roundedRectPath];
  
  STAssertEquals([unionPath elementCount], 13l, nil);
}

@end

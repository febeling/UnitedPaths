//
//  NSBezierPathIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentResegmentTest.h"
#import "TestHelper.h"

@implementation FLPathSegmentResegmentTest

- (void)setUp
{
  rect = [NSBezierPath bezierPathWithRect:NSMakeRect(0,0,4,4)];
  oval = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1,1,4,4)];
  
  rectSegs = [rect segments];
  ovalSegs = [oval segments];
  
  for(FLPathSegment *rectSeg in rectSegs) {
    for(FLPathSegment *ovalSeg in ovalSegs) {
      [rectSeg clipWith:ovalSeg];
    }
  }
  
  NSPoint points2[3] = {{2, 0},{1, 3},{3, 3}};
  lineSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0.5,0) endPoint:NSMakePoint(2.5,3)];
  curveSegment = [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) points:points2];
}

- (void)testClippingsInTestObjects
{
  STAssertEquals([[[rectSegs objectAtIndex:1] clippings] count], 1ul, nil);
  STAssertEquals([[[rectSegs objectAtIndex:2] clippings] count], 1ul, nil);
  
  STAssertEquals([[[ovalSegs objectAtIndex:2] clippings] count], 1ul, nil);
  STAssertEquals([[[ovalSegs objectAtIndex:3] clippings] count], 1ul, nil);
}

- (void)testResegmentCurve
{
  FLPathSegment *segment = [ovalSegs objectAtIndex:2];
  NSArray *clippedSegments = [segment resegment];
  
  STAssertEquals([clippedSegments count], 2ul, nil);
  
  FLPathSegment *newSegmentStart = [clippedSegments objectAtIndex:0];
  FLPathSegment *newSegmentEnd = [clippedSegments objectAtIndex:1];
  
  STAssertEquals([newSegmentStart endPoint], [newSegmentEnd startPoint], nil);
  STAssertEquals([segment startPoint], [newSegmentStart startPoint], nil);
  STAssertEquals([segment endPoint], [newSegmentEnd endPoint], nil);
}

- (void)testResegmentLine
{
  FLPathSegment *segment = [rectSegs objectAtIndex:2];
  NSArray *clippedSegments = [segment resegment];
  
  STAssertEquals([clippedSegments count], 2ul, nil);

  FLPathSegment *newSegmentStart = [clippedSegments objectAtIndex:0];
  FLPathSegment *newSegmentEnd = [clippedSegments objectAtIndex:1];

  STAssertEquals([newSegmentStart endPoint], [newSegmentEnd startPoint], nil);
  STAssertEquals([segment startPoint], [newSegmentStart startPoint], nil);
  STAssertEquals([segment endPoint], [newSegmentEnd endPoint], nil);
}

#pragma mark multiple intersections on line segment

- (void)testResegmentLine_MultipleNewSegments
{
  [lineSegment clipWith:curveSegment];
  NSArray *segments = [lineSegment resegment];
  
  STAssertEquals([segments count], 4ul, nil);
}

- (void)testResegmentLine_MultipleNewSegmentsFit
{
  [lineSegment clipWith:curveSegment];
  NSArray *segments = [lineSegment resegment];
  
  for(int i = 0; i < [segments count]-1; i++) {
    FLPathSegment *s0, *s1;
    s0 = [segments objectAtIndex:i];
    s1 = [segments objectAtIndex:i+1];
    AssertPointsEqualWithAccuracy([s0 endPoint], [s1 startPoint], 1.0e-4);
  }
}

#pragma mark multiple intersections on curve

- (void)testResegmentCurve_MultipleNewSegments
{
  [curveSegment clipWith:lineSegment];
  NSArray *segments = [curveSegment resegment];
  
  STAssertEquals([segments count], 4ul, nil);
}

- (void)testResegmentCurve_MultipleNewSegmentsFit
{
  [curveSegment clipWith:lineSegment];
  NSArray *segments = [lineSegment resegment];
  FLPathSegment *s0, *s1;
  
  for(int i = 0; i < [segments count]-1; i++) {
    s0 = [segments objectAtIndex:i];
    s1 = [segments objectAtIndex:i+1];
    STAssertEquals([s0 endPoint], [s1 startPoint], nil);
  }
}

@end

//
//  NSBezierPathIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentResegmentTest.h"

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
  STAssertEquals([[segment clippings] count], 1ul, nil);
  NSArray *clippedSegments = [segment resegment];
  
  STAssertEquals([clippedSegments count], 2ul, nil);
  
  FLPathSegment *newSegmentStart = [clippedSegments objectAtIndex:0];
  FLPathSegment *newSegmentEnd = [clippedSegments objectAtIndex:1];
  
  STAssertEquals([newSegmentStart endPoint], [newSegmentEnd startPoint], nil);
  STAssertEquals([segment startPoint], [newSegmentStart startPoint], nil);
  STAssertEquals([segment endPoint], [newSegmentEnd endPoint], nil);
}

@end

//
//  FLPathSegmentReassemble.m
//  BezierLab
//
//  Created by Florian Ebeling on 13.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentReassemble.h"
#import "TestHelper.h"
#import "NSBezierPath+BezierLabs.h"

@implementation FLPathSegmentReassemble

#pragma mark Rectangles overlapping at corner

#define D 1.0e-3

- (void)testClipSegments_RectOverlappingRectWithACorner
{
  NSBezierPath *topLeftPath = [NSBezierPath bezierPathWithRect:NSMakeRect(0,2,2,2)];
  NSBezierPath *bottomRightPath = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)];
  
  NSArray *array = [topLeftPath unionWithBezierPath:bottomRightPath];

  NSArray *expected = [NSArray arrayWithObjects:
                       @"<FLPathLineSegment startPoint: {0, 2}, endPoint: {1, 2}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {1, 2}, endPoint: {1, 1}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {1, 1}, endPoint: {3, 1}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {3, 1}, endPoint: {3, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {3, 3}, endPoint: {2, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {2, 3}, endPoint: {2, 4}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {2, 4}, endPoint: {0, 4}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {0, 4}, endPoint: {0, 2}, keep: YES>", nil];
  
  STAssertEqualObjects([array valueForKey:@"description"],
                       expected, nil);
}

#pragma mark Rectangle overlapping at full side, precisely

- (void)testClipSegments_SquareNextToSquare
{
  NSBezierPath *leftPath = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)];
  NSBezierPath *rightPath = [NSBezierPath bezierPathWithRect:NSMakeRect(2,1,2,2)];
  
  NSArray *array = [leftPath unionWithBezierPath:rightPath];
  
  NSArray *expected = [NSArray arrayWithObjects:
                       @"<FLPathLineSegment startPoint: {1, 1}, endPoint: {2, 1}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {2, 1}, endPoint: {3, 1}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {3, 1}, endPoint: {4, 1}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {4, 1}, endPoint: {4, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {4, 3}, endPoint: {3, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {3, 3}, endPoint: {2, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {2, 3}, endPoint: {1, 3}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {1, 3}, endPoint: {1, 1}, keep: YES>", nil];

  STAssertEqualObjects([array valueForKey:@"description"], expected, nil);
}

#pragma mark Square and Circle overlapping half

- (void)testClipSegments_SquareAndCircle
{
  NSBezierPath *squarePath = [NSBezierPath bezierPathWithRect:NSMakeRect(0,0,2,2)];
  NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1,0,2,2)];

  NSArray *array = [squarePath unionWithBezierPath:circlePath];
  
  NSArray *expected = [NSArray arrayWithObjects:
                       @"<FLPathLineSegment startPoint: {0, 0}, endPoint: {2, 0}, keep: YES>",
                       @"<FLPathCurveSegment start: {2, 0}, control1: {2.2559223176554561, -5.5511151231257827e-17}, control2: {2.5118446353109123, 0.097631072937817365}, end: {2.7071067811865475, 0.29289321881345232}, keep: YES>",
                       @"<FLPathCurveSegment start: {2.7071067811865475, 0.29289321881345254}, control1: {3.0976310729378174, 0.68341751056472244}, control2: {3.0976310729378174, 1.3165824894352776}, end: {2.7071067811865475, 1.7071067811865475}, keep: YES>",
                       @"<FLPathCurveSegment start: {2.7071067811865475, 1.7071067811865475}, control1: {2.5118446353109127, 1.9023689270621822}, control2: {2.2559223176554566, 1.9999999999999998}, end: {2.0000000000000004, 2}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {2, 2}, endPoint: {0, 2}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {0, 2}, endPoint: {0, 0}, keep: YES>", nil];
  
  STAssertEquals([array count], 6ul, nil);
  
  STAssertEqualObjects([array valueForKey:@"description"], expected, nil);
}

@end

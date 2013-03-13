//
//  FLPathSegmentReassemble.m
//  BezierLab
//
//  Created by Florian Ebeling on 13.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentReassemble.h"
#import "TestHelper.h"
#import "NSBezierPath+UnitedPaths.h"

@implementation FLPathSegmentReassemble

#pragma mark Rectangles overlapping at corner

#define D 1.0e-3

- (void)testReassemble_RectOverlappingRectWithACorner
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

- (void)testReassemble_SquareNextToSquare
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

- (void)testReassemble_SquareAndCircle
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

- (void)testReassemble_RoundedRectNextRect
{
  NSBezierPath *roundedRectPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(50, 250, 100, 100) xRadius:20 yRadius:20];
  NSBezierPath *rectPath = [NSBezierPath bezierPathWithRect:NSMakeRect(100, 250, 130, 100)];

  NSArray *array = [roundedRectPath unionWithBezierPath:rectPath];

  NSArray *expected = [NSArray arrayWithObjects:
                       @"<FLPathCurveSegment start: {70, 350}, control1: {58.9544, 350}, control2: {50, 341.04559999999998}, end: {50, 330}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {50, 330}, endPoint: {50, 270}, keep: YES>",
                       @"<FLPathCurveSegment start: {50, 270}, control1: {50, 258.95440000000002}, control2: {58.9544, 250}, end: {70, 250}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {70, 250}, endPoint: {100, 250}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {100, 250}, endPoint: {130, 250}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {130.00000000000014, 249.99999999999994}, endPoint: {230, 250}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {230, 250}, endPoint: {230, 350}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {230, 350}, endPoint: {129.99999999999983, 350}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {130, 350}, endPoint: {100, 350}, keep: YES>",
                       @"<FLPathLineSegment startPoint: {100, 350}, endPoint: {70, 350}, keep: YES>", nil];

  STAssertEquals([array count], 10ul, nil);
  STAssertEqualObjects([array valueForKey:@"description"], expected, nil);
}

@end

//
//  FLPathSegmentMarkUnionOf.m
//  BezierLab
//
//  Created by Florian Ebeling on 10.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentMarkUnionOf.h"

@implementation FLPathSegmentMarkUnionOf

#pragma mark Rectangles overlapping at corner

- (void)testClipSegments_RectOverlappingRectWithACorner
{
  NSMutableArray *topLeftRect = [[NSBezierPath bezierPathWithRect:NSMakeRect(0,2,2,2)] segments];
  NSMutableArray *bottomRightRect = [[NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)] segments];
  
  [FLPathSegment clipSegments:topLeftRect modifierSegments:bottomRightRect];
  
  STAssertEquals([topLeftRect count], 6ul, nil);
  STAssertEquals([bottomRightRect count], 6ul, nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:0], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,2) endPoint:NSMakePoint(1,2)], nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:1], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,2) endPoint:NSMakePoint(2,2)], nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:2], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,2) endPoint:NSMakePoint(2,3)], nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:3], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,3) endPoint:NSMakePoint(2,4)], nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:4], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,4) endPoint:NSMakePoint(0,4)], nil);
  STAssertEqualObjects([topLeftRect objectAtIndex:5], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,4) endPoint:NSMakePoint(0,2)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:0], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(3,1)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:1], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,1) endPoint:NSMakePoint(3,3)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:2], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,3) endPoint:NSMakePoint(2,3)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:3], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,3) endPoint:NSMakePoint(1,3)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:4], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,3) endPoint:NSMakePoint(1,2)], nil);
  STAssertEqualObjects([bottomRightRect objectAtIndex:5], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,2) endPoint:NSMakePoint(1,1)], nil);
}

- (void)testMarkUnion_RectOverlappingRectWithACorner
{
  NSBezierPath *topLeftPath = [NSBezierPath bezierPathWithRect:NSMakeRect(0,2,2,2)];
  NSMutableArray *topLeftRect = [topLeftPath segments];
  NSBezierPath *bottomRightPath = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)];
  NSMutableArray *bottomRightRect = [bottomRightPath segments];
  
  [FLPathSegment clipSegments:topLeftRect modifierSegments:bottomRightRect];
  NSPoint externalPoint = [topLeftPath externalPointWithModifier:bottomRightPath];
  [FLPathSegment markUnionOf:topLeftRect withModifiers:bottomRightRect outsidePoint:externalPoint];
  [FLPathSegment markUnionOf:bottomRightRect withModifiers:topLeftRect outsidePoint:externalPoint];
  
  STAssertEquals([[topLeftRect objectAtIndex:0] keep], YES, nil);
  STAssertEquals([[topLeftRect objectAtIndex:1] keep], NO, nil);
  STAssertEquals([[topLeftRect objectAtIndex:2] keep], NO, nil);
  STAssertEquals([[topLeftRect objectAtIndex:3] keep], YES, nil);
  STAssertEquals([[topLeftRect objectAtIndex:4] keep], YES, nil);
  STAssertEquals([[topLeftRect objectAtIndex:5] keep], YES, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:0] keep], YES, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:1] keep], YES, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:2] keep], YES, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:3] keep], NO, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:4] keep], NO, nil);
  STAssertEquals([[bottomRightRect objectAtIndex:5] keep], YES, nil);
}

#pragma mark rectangle overlapping at full side, precisely

- (void)testClipSegments_SquareNextToSquare
{
  NSBezierPath *leftPath = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)];
  NSBezierPath *rightPath = [NSBezierPath bezierPathWithRect:NSMakeRect(2,1,2,2)];
  NSMutableArray *left = [leftPath segments];
  NSMutableArray *right = [rightPath segments];
  
  [FLPathSegment clipSegments:left modifierSegments:right];
  
  STAssertEquals([left count], 6ul, nil);
  STAssertEquals([right count], 6ul, nil);
  STAssertEqualObjects([left objectAtIndex:0], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,1)], nil);
  STAssertEqualObjects([left objectAtIndex:1], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,1) endPoint:NSMakePoint(3,1)], nil);
  STAssertEqualObjects([left objectAtIndex:2], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,1) endPoint:NSMakePoint(3,3)], nil);
  STAssertEqualObjects([left objectAtIndex:3], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,3) endPoint:NSMakePoint(2,3)], nil);
  STAssertEqualObjects([left objectAtIndex:4], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,3) endPoint:NSMakePoint(1,3)], nil);
  STAssertEqualObjects([left objectAtIndex:5], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(1,3) endPoint:NSMakePoint(1,1)], nil);
  STAssertEqualObjects([right objectAtIndex:0], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,1) endPoint:NSMakePoint(3,1)], nil);
  STAssertEqualObjects([right objectAtIndex:1], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,1) endPoint:NSMakePoint(4,1)], nil);
  STAssertEqualObjects([right objectAtIndex:2], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(4,1) endPoint:NSMakePoint(4,3)], nil);
  STAssertEqualObjects([right objectAtIndex:3], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(4,3) endPoint:NSMakePoint(3,3)], nil);
  STAssertEqualObjects([right objectAtIndex:4], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(3,3) endPoint:NSMakePoint(2,3)], nil);
  STAssertEqualObjects([right objectAtIndex:5], [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,3) endPoint:NSMakePoint(2,1)], nil);
}

- (void)testMarkUnion_SquareNextToSquare
{
  NSBezierPath *leftPath = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,2,2)];
  NSBezierPath *rightPath = [NSBezierPath bezierPathWithRect:NSMakeRect(2,1,2,2)];
  NSMutableArray *left = [leftPath segments];
  NSMutableArray *right = [rightPath segments];
  
  NSPoint point = [leftPath externalPointWithModifier:rightPath];
  
  [FLPathSegment clipSegments:left modifierSegments:right];
  [FLPathSegment markUnionOf:left withModifiers:right outsidePoint:point];
  [FLPathSegment markUnionOf:right withModifiers:left outsidePoint:point];
  
  STAssertEquals([[left objectAtIndex:0] keep], YES, nil);
  STAssertEquals([[left objectAtIndex:1] keep], YES, nil); // duplicate segment
  STAssertEquals([[left objectAtIndex:2] keep], NO, nil);
  STAssertEquals([[left objectAtIndex:3] keep], YES, nil); // duplicate segment
  STAssertEquals([[left objectAtIndex:4] keep], YES, nil);
  STAssertEquals([[left objectAtIndex:5] keep], YES, nil);
  STAssertEquals([[right objectAtIndex:0] keep], YES, nil); // duplicate segment
  STAssertEquals([[right objectAtIndex:1] keep], YES, nil);
  STAssertEquals([[right objectAtIndex:2] keep], YES, nil);
  STAssertEquals([[right objectAtIndex:3] keep], YES, nil);
  STAssertEquals([[right objectAtIndex:4] keep], YES, nil); // duplicate segment
  STAssertEquals([[right objectAtIndex:5] keep], NO, nil);
  
  STAssertEqualObjects([left objectAtIndex:1], [right objectAtIndex:0], @"bottom duplicate segment");
  STAssertEqualObjects([left objectAtIndex:3], [right objectAtIndex:4], @"top duplicate segment");
}

#pragma mark square and circle overlapping half

- (void)testClipSegments_SquareAndCircle
{
  NSBezierPath *squarePath = [NSBezierPath bezierPathWithRect:NSMakeRect(0,0,2,2)];
  NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1,0,2,2)];
  NSMutableArray *square = [squarePath segments];
  NSMutableArray *circle = [circlePath segments];
  
  [FLPathSegment clipSegments:square modifierSegments:circle];
  
  STAssertEquals([square count], 4ul, nil);
  STAssertEquals([circle count], 6ul, nil);
  
  // TODO check circle segments before and after resegmentation
}

@end

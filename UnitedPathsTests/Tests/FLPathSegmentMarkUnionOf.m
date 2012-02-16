//
//  FLPathSegmentMarkUnionOf.m
//  BezierLab
//
//  Created by Florian Ebeling on 10.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentMarkUnionOf.h"
#import "FLPathSegment.h"

@implementation FLPathSegmentMarkUnionOf

#pragma mark Rectangles overlapping at corner

#define D 1.0e-3

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
  
  NSPoint point = [squarePath externalPointWithModifier:circlePath];
  
  [FLPathSegment markUnionOf:square withModifiers:circle outsidePoint:point];
  [FLPathSegment markUnionOf:circle withModifiers:square outsidePoint:point];
  
  STAssertEquals([square count], 4ul, nil);
  STAssertEquals([circle count], 6ul, nil);

  {
    FLPathCurveSegment *segment = [circle objectAtIndex:0];
    STAssertEquals(segment.keep, YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(2.707, 0.292), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(2.707, 1.707), D);
    
    segment = [circle objectAtIndex:1];
    STAssertEquals(segment.keep, YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(2.707, 1.707), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(2.000, 2.000), D);
    
    segment = [circle objectAtIndex:2];
    STAssertEquals(segment.keep, NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(2.000, 2.000), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(1.292, 1.707), D);
    
    segment = [circle objectAtIndex:3];
    STAssertEquals(segment.keep, NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(1.292, 1.707), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(1.292, 0.292), D);
    
    segment = [circle objectAtIndex:4];
    STAssertEquals(segment.keep, NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(1.292, 0.292), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(2.000, 0.000), D);
    
    segment = [circle objectAtIndex:5];
    STAssertEquals(segment.keep, YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(2.000, 0.000), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(2.707, 0.292), D);
  }
  
  {
    FLPathLineSegment *segment = [square objectAtIndex:0];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,0) endPoint:NSMakePoint(2,0)], nil);
    
    segment = [square objectAtIndex:1];
    STAssertEquals([segment keep], NO, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,0) endPoint:NSMakePoint(2,2)], nil);

    segment = [square objectAtIndex:2];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(2,2) endPoint:NSMakePoint(0,2)], nil);

    segment = [square objectAtIndex:3];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(0,2) endPoint:NSMakePoint(0,0)], nil);
  }
}

#pragma mark -

- (void)testClipSegmentsAndMarkUnion_TwoRoundedRects
{
  NSBezierPath *rect1 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(100, 100, 200, 100)
                                                        xRadius:20
                                                        yRadius:20];
  NSMutableArray *segments1 = [rect1 segments];
  NSBezierPath *rect2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(150, 150, 200, 100)
                                                        xRadius:20
                                                        yRadius:20];
  NSMutableArray *segments2 = [rect2 segments];

  NSPoint point = [rect1 externalPointWithModifier:rect2];

  [FLPathSegment clipSegments:segments1 modifierSegments:segments2];
  [FLPathSegment markUnionOf:segments1 withModifiers:segments2 outsidePoint:point];
  [FLPathSegment markUnionOf:segments2 withModifiers:segments1 outsidePoint:point];

  STAssertEquals([segments1 count], 10ul, nil);
  
  {
    FLPathSegment *segment = [segments1 objectAtIndex:0];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(120, 200), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(100, 180), D);
    
    segment = [segments1 objectAtIndex:1];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(100, 180)
                                                                  endPoint:NSMakePoint(100, 120)], nil);
    segment = [segments1 objectAtIndex:2];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(100, 120), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(120, 100), D);
    
    segment = [segments1 objectAtIndex:3];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(120, 100)
                                                                  endPoint:NSMakePoint(280, 100)], nil);
    
    segment = [segments1 objectAtIndex:4];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(280, 100), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(300, 120), D);
    
    segment = [segments1 objectAtIndex:5];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(300, 120)
                                                                  endPoint:NSMakePoint(300, 150)], nil);
    
    segment = [segments1 objectAtIndex:6];
    STAssertEquals([segment keep], NO, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(300, 150)
                                                                  endPoint:NSMakePoint(300, 180)], nil);
    segment = [segments1 objectAtIndex:7];
    STAssertEquals([segment keep], NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(300, 180), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(280, 200), D);
    
    segment = [segments1 objectAtIndex:8];
    STAssertEquals([segment keep], NO, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(280, 200)
                                                                  endPoint:NSMakePoint(150, 200)], nil);
    
    segment = [segments1 objectAtIndex:9];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(150, 200)
                                                                  endPoint:NSMakePoint(120, 200)], nil);
  }
  
  {
    STAssertEquals([segments2 count], 10ul, nil);
    
    FLPathSegment *segment = [segments2 objectAtIndex:0];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(170, 250), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(150, 230), D);
    
    segment = [segments2 objectAtIndex:1];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(150, 230)
                                                                  endPoint:NSMakePoint(150, 200)], nil);
    segment = [segments2 objectAtIndex:2];
    STAssertEquals([segment keep], NO, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(150, 200)
                                                                  endPoint:NSMakePoint(150, 170)], nil);
    segment = [segments2 objectAtIndex:3];
    STAssertEquals([segment keep], NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(150, 170), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(170, 150), D);
    
    segment = [segments2 objectAtIndex:4];
    STAssertEquals([segment keep], NO, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(170, 150)
                                                                  endPoint:NSMakePoint(300, 150)], nil);
    segment = [segments2 objectAtIndex:5];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(300, 150)
                                                                  endPoint:NSMakePoint(330, 150)], nil);
    segment = [segments2 objectAtIndex:6];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(330, 150), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(350, 170), D);

    segment = [segments2 objectAtIndex:7];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(350, 170)
                                                                  endPoint:NSMakePoint(350, 230)], nil);
    segment = [segments2 objectAtIndex:8];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(350, 230), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(330, 250), D);
    
    segment = [segments2 objectAtIndex:9];
    STAssertEquals([segment keep], YES, nil);
    STAssertEqualObjects(segment, [FLPathSegment pathSegmentWithStartPoint:NSMakePoint(330, 250)
                                                                  endPoint:NSMakePoint(170, 250)], nil);
  }
}

- (void)testClipAndMarkUnion_RoundedRectOverlappedByRect
{
  // As in keyboard shapes in demo app. This test reproduces a bug with
  // duplicate, but only similar (not equal) segments.
  NSBezierPath *roundedRectPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(50, 250, 100, 100) xRadius:20 yRadius:20];
  NSBezierPath *rectPath = [NSBezierPath bezierPathWithRect:NSMakeRect(100, 250, 130, 100)];

  NSMutableArray *roundedRectSegments = [roundedRectPath segments];
  NSMutableArray *rectSegments = [rectPath segments];
  
  NSPoint point = [roundedRectPath externalPointWithModifier:rectPath];
  
  [FLPathSegment clipSegments:roundedRectSegments modifierSegments:rectSegments];
  [FLPathSegment markUnionOf:roundedRectSegments withModifiers:rectSegments outsidePoint:point];
  [FLPathSegment markUnionOf:rectSegments withModifiers:roundedRectSegments outsidePoint:point];

  {
    FLPathSegment *segment;
    
    segment = [roundedRectSegments objectAtIndex:0];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(70, 350), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(50, 330), D);
    
    segment = [roundedRectSegments objectAtIndex:1];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(50, 330), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(50, 270), D);
    
    segment = [roundedRectSegments objectAtIndex:2];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(50, 270), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(70, 250), D);
    
    segment = [roundedRectSegments objectAtIndex:3];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(70, 250), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(100, 250), D);
    
    segment = [roundedRectSegments objectAtIndex:4];
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(100, 250), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(130, 250), D);
    
    segment = [roundedRectSegments objectAtIndex:5];
    STAssertEquals([segment keep], NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(130, 250), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(150, 270), D);
    
    segment = [roundedRectSegments objectAtIndex:6];
    STAssertEquals([segment keep], NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(150, 270), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(150, 330), D);
    
    segment = [roundedRectSegments objectAtIndex:7];
    STAssertEquals([segment keep], NO, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(150, 330), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(130, 350), D);
    
    segment = [roundedRectSegments objectAtIndex:8]; // duplicate (similar)
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(130, 350), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(100, 350), D);

    segment = [roundedRectSegments objectAtIndex:9]; // duplicate (similar)
    STAssertEquals([segment keep], YES, nil);
    AssertPointsEqualWithAccuracy([segment startPoint], NSMakePoint(100, 350), D);
    AssertPointsEqualWithAccuracy([segment endPoint], NSMakePoint(70, 350), D);
  }
  
  NSBezierPath *unionPath = [roundedRectPath bezierPathByUnionWith:rectPath];
  
  STAssertEquals([unionPath elementCount], 12l, nil);
}

@end

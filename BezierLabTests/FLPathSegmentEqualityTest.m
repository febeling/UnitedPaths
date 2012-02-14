//
//  FLPathSegmentEquality.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegmentEqualityTest.h"

@implementation FLPathSegmentEqualityTest

#pragma mark isEqual

- (void)testEqual
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  
  STAssertFalse(one == other, nil);
  STAssertEqualObjects(one, other, nil);
  STAssertTrue([one isCloseToEqual: other], nil);
}

- (void)testNotEqual_DifferentEndPoint
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(4,4)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
  STAssertFalse([one isCloseToEqual: other], nil);
}

- (void)testNotEqual_DifferentStartPoint
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(0,0) endPoint:NSMakePoint(2,2)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
  STAssertFalse([one isCloseToEqual: other], nil);
}

- (void)testNotEqual_DifferentKind
{
  one = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                         controlPoint1:NSMakePoint(2,2)
                                         controlPoint2:NSMakePoint(3,3)
                                              endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
  STAssertFalse([one isCloseToEqual: other], nil);

  STAssertEquals([one startPoint], [other startPoint], nil);
  STAssertEquals([one endPoint], [other endPoint], nil);
}

- (void)testNotEqual_DifferentControlPoint1
{
  one = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                         controlPoint1:NSMakePoint(0,0)
                                         controlPoint2:NSMakePoint(3,3)
                                              endPoint:NSMakePoint(4,4)];
  other = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                           controlPoint1:NSMakePoint(2,2)
                                           controlPoint2:NSMakePoint(3,3)
                                                endPoint:NSMakePoint(4,4)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
  STAssertFalse([one isCloseToEqual: other], nil);
}

- (void)testNotEqual_LineIsNotEqualCurveWithEqualStartAndEndPoints
{
  one =   [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                           controlPoint1:NSMakePoint(2,2)
                                           controlPoint2:NSMakePoint(3,3)
                                                endPoint:NSMakePoint(2,2)];
  STAssertFalse([one isEqual:other], nil);
  STAssertFalse([other isEqual:one], nil);
}

#pragma mark isCloseToEqual: 

- (void)testIsCloseToEqual_StartPointClose
{
  one =   [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1.0000000003) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];

  STAssertTrue([one isCloseToEqual:other], nil);
}

- (void)testIsCloseToEqual_EndPointClose
{
  one =   [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1.) endPoint:NSMakePoint(2.00000000003,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,1.999999999997)];
  
  STAssertTrue([one isCloseToEqual:other], nil);
}

- (void)testIsCloseToEqual_EqualButCurveAndLine
{
  one =   [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1.) endPoint:NSMakePoint(2.00000000003,2)];
  other = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                          controlPoint1:NSMakePoint(2,2)
                                          controlPoint2:NSMakePoint(3,3)
                                                endPoint:NSMakePoint(2,2)];
  
  STAssertFalse([one isCloseToEqual:other], nil);
}

- (void)testIsCloseToEqual_CloseCurves
{
  one = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1.00000000000001,1)
                                         controlPoint1:NSMakePoint(2,2.0000000005)
                                         controlPoint2:NSMakePoint(2.99999999994,3)
                                              endPoint:NSMakePoint(4,3.99999999994)];
  other = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1)
                                           controlPoint1:NSMakePoint(2,2)
                                           controlPoint2:NSMakePoint(3,3)
                                                endPoint:NSMakePoint(4,4)];
  
  STAssertTrue([one isCloseToEqual:other], nil);
}

#pragma mark hash

- (void)testHash_Line
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  
  STAssertNoThrow([one hash], nil);
}

- (void)testHash_Curve
{
  one = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,3) endPoint:NSMakePoint(2,2)];
  
  STAssertNoThrow([one hash], nil);
}

- (void)testHash_CurveAndLineHashDiffer
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(1,1) controlPoint1:NSMakePoint(2,2) controlPoint2:NSMakePoint(3,3) endPoint:NSMakePoint(2,2)];

  STAssertFalse([one hash] == [other hash], nil);
}

@end

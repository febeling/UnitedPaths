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
}

- (void)testNotEqual_DifferentEndPoint
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(4,4)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
}

- (void)testNotEqual_DifferentStartPoint
{
  one = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(2,2)];
  other = [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(0,0) endPoint:NSMakePoint(2,2)];
  
  STAssertFalse(one == other, nil);
  STAssertFalse([one isEqual:other], nil);
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

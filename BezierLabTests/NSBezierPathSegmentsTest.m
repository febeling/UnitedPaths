//
//  NSBezierPathSegmentsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPathSegmentsTest.h"

@implementation NSBezierPathSegmentsTest

- (void)testSegmtents_Rect
{
  rect = [NSBezierPath bezierPathWithRect:NSMakeRect(1,1,3,2)];
  
  NSMutableArray *segments = [rect segments];
  
  STAssertEquals([segments count], 4ul, nil);
  
  STAssertEqualObjects([segments objectAtIndex:0],
                       [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,1) endPoint:NSMakePoint(4,1)], nil);
  STAssertEqualObjects([segments objectAtIndex:1],
                       [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(4,1) endPoint:NSMakePoint(4,3)], nil);
  STAssertEqualObjects([segments objectAtIndex:2],
                       [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(4,3) endPoint:NSMakePoint(1,3)], nil);
  STAssertEqualObjects([segments objectAtIndex:3],
                       [[FLPathLineSegment alloc] initWithStartPoint:NSMakePoint(1,3) endPoint:NSMakePoint(1,1)], nil);
}

- (void)testSegmtents_Oval
{
  oval = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1,1,3,2)];

  NSMutableArray *segments = [oval segments];
  
  STAssertEquals([segments count], 4ul, nil);
    
  STAssertEqualObjects([segments objectAtIndex:0],
                       [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(3.5606601717798214, 1.2928932188134525)
                                                        controlPoint1:NSMakePoint(4.146446609406726, 1.6834175105647224)
                                                        controlPoint2:NSMakePoint(4.146446609406726, 2.3165824894352776)
                                                             endPoint:NSMakePoint(3.5606601717798214, 2.7071067811865475)], nil);
  
  STAssertEqualObjects([segments objectAtIndex:1],
                       [[FLPathCurveSegment alloc] initWithStartPoint:NSMakePoint(3.5606601717798214, 2.7071067811865475)
                                                        controlPoint1:NSMakePoint(2.9748737341529163, 3.0976310729378174)
                                                        controlPoint2:NSMakePoint(2.0251262658470837, 3.0976310729378174)
                                                             endPoint:NSMakePoint(1.4393398282201788, 2.70710678118654754)], nil);
}

@end

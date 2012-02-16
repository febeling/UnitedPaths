//
//  FLIntersectionTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 06.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLIntersectionTest.h"

@implementation FLIntersectionTest

- (void)testReprojectIntersection
{
  FLIntersection *i = [[FLIntersection alloc] initWithPoint:NSMakePoint(1,1) time:0.7];
  
  [i reprojectWithTime:0.3];
  
  STAssertEqualsWithAccuracy([i time], 0.571, 1.0e-3, nil);
}

@end

//
//  NSValueWithPointBugTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 05.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSValueWithPointBugTest.h"

@implementation NSValueWithPointBugTest

// TODO Check rect, and size, too.

- (void)testNSValuePointHash
{
  // bug filed as radar://10803970
  NSValue *v1 = [NSValue valueWithPoint:NSMakePoint(1,1)];
  NSValue *v2 = [NSValue valueWithPoint:NSMakePoint(2,2)];
  
  STAssertEquals([v1 hash], [v2 hash], @"When this fails the NSValue point hash bug has been fixed!");
}

- (void)testNSValuePointHashLoop
{
  NSValue *v1 = [NSValue valueWithPoint:NSMakePoint(1,1)];
  
  for(int i = -1000; i < 1000; i++) {
    NSValue *v2 = [NSValue valueWithPoint:NSMakePoint(i,i)];
    STAssertTrue([v1 hash] == [v2 hash], @"fail with i: %dl", i);
  }
}

- (void)testPointValueEquality
{
  STAssertEqualObjects([NSValue valueWithPoint:NSMakePoint(1,1)], [NSValue valueWithPoint:NSMakePoint(1,1)], nil);
  STAssertFalse([[NSValue valueWithPoint:NSMakePoint(1,1)] isEqual:[NSValue valueWithPoint:NSMakePoint(2,2)]], nil);
  STAssertFalse([[NSValue valueWithPoint:NSMakePoint(1,1)] isEqual:[NSValue valueWithPoint:NSMakePoint(2,0)]], nil);
}

@end

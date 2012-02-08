//
//  NSBezierPathBehaviorTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 08.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPathBehaviorTest.h"

@implementation NSBezierPathBehaviorTest

- (void)testCreatingPathFristNeedsAMoveToCommand
{
  STAssertThrows([[NSBezierPath bezierPath] lineToPoint:NSMakePoint(1,1)], nil);
  STAssertThrows([[NSBezierPath bezierPath] curveToPoint:NSMakePoint(1,1)
                                           controlPoint1:NSMakePoint(1,2)
                                           controlPoint2:NSMakePoint(2,2)], nil);
  STAssertNoThrow([[NSBezierPath bezierPath] moveToPoint:NSMakePoint(1,1)], nil);
}

- (void)testCreatingPathFristNeedsAMoveToCommand_CloseInsertsMove
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(1,1)];
  [path closePath];
  
  STAssertEquals([path elementCount], 3l, nil);
}

- (void)testCreatingPathFristNeedsAMoveToCommand_CloseWithoutCurrentPointDoesNothing
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path closePath];
  
  STAssertEquals([path elementCount], 0l, nil);
}

@end

//
//  NSBezierPathIntersectionsTest.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPathIntersectionsTest.h"

@implementation NSBezierPathIntersectionsTest

- (void)testIntersections_RectAndOval
{
  rect = [NSBezierPath bezierPathWithRect:NSMakeRect(0,0,5,5)];
  oval = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(2,2,5,5)];
  
  NSArray *intersections = [rect intersectionsWithBezierPath:oval];
  
  STAssertNotNil(intersections, nil);
//  STAssertEquals([intersections count], 2ul, nil);
}

@end

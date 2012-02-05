//
//  NSBezierPathIntersectionsTest.h
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FLPathSegment.h"
#import "NSBezierPath+BezierLabs.h"

@interface FLPathSegmentResegmentTest : SenTestCase
{
  NSBezierPath *rect;
  NSBezierPath *oval;
  NSMutableArray *rectSegs;
  NSMutableArray *ovalSegs;
}

@end

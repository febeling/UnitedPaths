//
//  NSBezierPathSegmentsTest.h
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSBezierPath+UnitedPaths.h"
#import "FLPathSegment.h"

@interface NSBezierPathSegmentsTest : SenTestCase
{
  NSBezierPath *rect;  
  NSBezierPath *oval;
  FLPathSegment *segment;
}
@end

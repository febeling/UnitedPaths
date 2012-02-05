//
//  FLIntersection.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLIntersection.h"

@implementation FLIntersection

- (id)initWithPoint:(NSPoint)aPoint time:(CGFloat)time
{
  self = [super init];
  if(self) {
    point = aPoint;
    t = time;
  }
  
  return self;
}

- (id)initWithPoint:(NSPoint)aPoint
{
  return [self initWithPoint:aPoint time:-1];
}

- (NSPoint)point
{
  return point;
}

- (CGFloat)time
{
  return t;
}

- (BOOL)isEqual:(id)other // test
{
  if(![other isKindOfClass:[self class]]) return NO;
  
  FLIntersection *otherIntersection = (FLIntersection *)other;
  
  return NSEqualPoints([otherIntersection point], point) && [otherIntersection time] == t;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@ point: %@, time: %.16f>", [self className], NSStringFromPoint(point), t];
}

@end

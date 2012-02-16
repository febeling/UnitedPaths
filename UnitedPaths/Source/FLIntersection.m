//
//  FLIntersection.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLIntersection.h"

@implementation FLIntersection

- (id)initWithPoint:(NSPoint)aPoint time:(CGFloat)t
{
  self = [super init];
  if(self) {
    point = aPoint;
    time = t;
  }
  
  return self;
}

- (id)initWithPoint:(NSPoint)aPoint
{
  return [self initWithPoint:aPoint time:-1];
}

- (id)copyWithZone:(NSZone *)zone
{
  FLIntersection *copy = [[[self class] allocWithZone:zone] initWithPoint:point time:time];
  
  return copy;
}

- (void)reprojectWithTime:(CGFloat)sectionTime
{
  time = (time-sectionTime) * 1.0/(1.0-sectionTime);
}

@synthesize point = point;
@synthesize time = time;

- (BOOL)isEqual:(id)other
{
  if(![other isKindOfClass:[self class]]) return NO;
  
  FLIntersection *otherIntersection = (FLIntersection *)other;
  
  return NSEqualPoints([otherIntersection point], point) && [otherIntersection time] == time;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@ point: %@, time: %.16f>", [self className], NSStringFromPoint(point), time];
}

@end

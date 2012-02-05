//
//  FLPathSegment.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegment.h"
#import "FLGeometry.h"
#import "FLIntersection.h"

#define NSUINT_BIT (8 * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

#pragma mark FLPathSegment

@implementation FLPathSegment

+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint
{
  return [[FLPathLineSegment alloc] initWithStartPoint:theStartPoint endPoint:theEndPoint];
}

+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint points:(NSPoint *)points
{
  return [[FLPathCurveSegment alloc] initWithStartPoint:theStartPoint points:points];
}

+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint
                  controlPoint1:(NSPoint)theControlPoint1
                  controlPoint2:(NSPoint)theControlPoint2
                       endPoint:(NSPoint)theEndPoint
{
  return [[FLPathCurveSegment alloc] initWithStartPoint:theStartPoint
                                          controlPoint1:theControlPoint1
                                          controlPoint2:theControlPoint2
                                               endPoint:theEndPoint];
}

- (id)initWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint
{
  self = [super init];
  if(self) {
    startPoint = theStartPoint;
    endPoint = theEndPoint;
    clippings = [NSMutableArray array];
  }
  
  return self;
}

@synthesize clippings;

- (NSBezierPathElement)element
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];

  return 0;
}

- (void)clipWith:(FLPathSegment *)modifier
{
  [[self clippings] removeAllObjects];
  [[modifier clippings] removeAllObjects];
  FLPathSegmentIntersections(self, modifier);
}

- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];
}

- (NSPoint)startPoint
{
  return startPoint;
}

- (NSPoint)endPoint
{
  return endPoint;
}

- (void)points:(NSPoint *)points
{
  // overridden.
}

- (NSUInteger)hash
{
  return NSUINTROTATE([NSStringFromPoint(startPoint) hash], NSUINT_BIT / 2) ^ [NSStringFromPoint(endPoint) hash];
}

- (BOOL)isEqual:(id)other
{
  if(![other isKindOfClass:[self class]]) return NO;
  
  FLPathSegment *otherSegment = (FLPathSegment *)other;
  
  return NSEqualPoints([otherSegment startPoint], startPoint) &&
         NSEqualPoints([otherSegment endPoint], endPoint);
}

@end

#pragma mark FLPathLineSegment

@implementation FLPathLineSegment

- (NSBezierPathElement)element
{
  return NSLineToBezierPathElement;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@ startPoint: %@, endPoint: %@>", [self className], startPoint, endPoint];
}

- (void)points:(NSPoint *)points
{
  points[0] = [self endPoint];
}

- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first
{
  for(int i = 0; i < [intersections count]; i++) {
    NSPoint point = [[intersections objectAtIndex:i] pointValue];
    FLIntersection *intersection = [[FLIntersection alloc] initWithPoint:point];
    [[self clippings] addObject:intersection];
  }
}

@end

#pragma mark FLPathCurveSegment

@implementation FLPathCurveSegment

- (id)initWithStartPoint:(NSPoint)theStartPoint
           controlPoint1:(NSPoint)theControlPoint1
           controlPoint2:(NSPoint)theControlPoint2
                endPoint:(NSPoint)theEndPoint
{
  self = [super initWithStartPoint:theStartPoint endPoint:theEndPoint];
  if(self) {
    controlPoint1 = theControlPoint1;
    controlPoint2 = theControlPoint2;
  }
  
  return self;
}

- (id)initWithStartPoint:(NSPoint)theStartPoint points:(NSPoint *)points
{
  return [self initWithStartPoint:theStartPoint controlPoint1:points[0] controlPoint2:points[1] endPoint:points[2]];
}

- (NSBezierPathElement)element
{
  return NSCurveToBezierPathElement;
}

- (NSPoint)controlPoint1
{
  return controlPoint1;
}

- (NSPoint)controlPoint2
{
  return controlPoint2;
}

- (void)points:(NSPoint *)points
{
  points[0] = [self controlPoint1];
  points[1] = [self controlPoint2];
  points[2] = [self endPoint];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@\n   startPoint: %@,\n   controlPoint1: %@,\n   controlPoint2: %@,\n   endPoint: %@>",
          [self className], startPoint, controlPoint1, controlPoint2, endPoint];
}

- (BOOL)isEqual:(id)other
{
  BOOL result = [super isEqual:other];
  
  return result && NSEqualPoints([(FLPathCurveSegment *)other controlPoint1], self.controlPoint1) && NSEqualPoints([(FLPathCurveSegment *)other controlPoint2], self.controlPoint2);
}

- (NSUInteger)hash
{
  int i = 0;
  NSUInteger value = [super hash];
  return NSUINTROTATE(value, i++ * NSUINT_BIT / 3) 
         ^ NSUINTROTATE([NSStringFromPoint(controlPoint1) hash], i++ * NSUINT_BIT / 3)
         ^ NSUINTROTATE([NSStringFromPoint(controlPoint1) hash], i++ * NSUINT_BIT / 3);
}

- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first
{
  NSString *timeKey = first ? @"t0" : @"t1";
  
  for(int i = 0; i < [intersections count]; i++) {
    NSPoint point = [[intersections objectAtIndex:i] pointValue];
    CGFloat t0 = [[[info objectAtIndex:i] objectForKey:timeKey] doubleValue];
    FLIntersection *intersection = [[FLIntersection alloc] initWithPoint:point time:t0];
    [[self clippings] addObject:intersection];
  }
}

@end

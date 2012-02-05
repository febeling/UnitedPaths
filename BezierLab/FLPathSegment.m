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
  FLPathSegmentIntersections(self, modifier);
}

- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];
}

- (NSArray *)resegment
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];

  return nil;
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
  return [NSString stringWithFormat:@"<%@ startPoint: %@, endPoint: %@>",
          [self className],
          NSStringFromPoint(startPoint),
          NSStringFromPoint(endPoint)];
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
          [self className],
          NSStringFromPoint(startPoint),
          NSStringFromPoint(controlPoint1),
          NSStringFromPoint(controlPoint2),
          NSStringFromPoint(endPoint)];
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

- (NSArray *)resegment
{
  NSMutableArray *array = [NSMutableArray array];
  NSPoint points[3];
  FLCurve *splits;
  
  for(FLIntersection *intersection in [self clippings]) {
    NSLog(@"intersection: %@", intersection);
    // TODO this only works for one clipping point now. If there are
    // more, then after the first split, the recorded time value for
    // the clips are not correct any longer.
    // In theory it works this way:
    // t3 = (t2-t1) * 1/(1-t1). This represents the value of t2 projected onto the — smaller than the original — subcurve. (from: Bezier Info)
    
    [self points:points];
    FLSplitCurveFromPoints([intersection time], startPoint, points, &splits);
    
    FLPathSegment *newSegment0 = [FLPathSegment pathSegmentWithStartPoint:splits[0].startPoint points:splits[0].controlPoints];
    FLPathSegment *newSegment1 = [FLPathSegment pathSegmentWithStartPoint:splits[1].startPoint points:splits[1].controlPoints];
    [array addObject:newSegment0];
    [array addObject:newSegment1];
  }
  
  return array;
}

@end

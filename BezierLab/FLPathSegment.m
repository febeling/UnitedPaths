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
#import "NSBezierPath+BezierLabs.h" // TODO Remove circular dependency

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

#pragma mark FLPathSegment

@implementation FLPathSegment

+ (void)replaceClippedSegments:(NSMutableArray *)segments
{
  NSMutableDictionary *originals = [NSMutableDictionary dictionary];
  for(id segment in segments) {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:[segment hash]];
    [originals setObject:segment forKey:key];
  }
  
  NSMutableDictionary *replacements = [NSMutableDictionary dictionary];
  for(FLPathSegment *segment in segments) {
    NSArray *replacement = [segment resegment];
    if([replacement count] > 0) {
      NSNumber *key = [NSNumber numberWithUnsignedInteger:[segment hash]];
      [replacements setObject:replacement forKey:key];
    }
  }
  
  for(NSNumber *segmentKey in replacements) {
    FLPathSegment *segment = [originals objectForKey:segmentKey];
    NSRange range = NSMakeRange([segments indexOfObject:segment], 1);
    [segments replaceObjectsInRange:range withObjectsFromArray:[replacements objectForKey:segmentKey]];
  }
}

+ (void)markCombinationOf:(NSArray *)segments
             withModifier:(NSArray *)segmentsModifier
             outsidePoint:(NSPoint)outsidePoint
                     even:(BOOL)even
{
  for(FLPathSegment *segment in segments) {
    int num = 0;
    FLPathSegment *lineToOutside = [FLPathSegment pathSegmentWithStartPoint:[segment midPoint] endPoint:outsidePoint];

    for(FLPathSegment *modSegment in segmentsModifier) {

      if(even && [segment isEqual: modSegment]) { // TODO is this special for Union?
        segment.keep = YES;
        break;
      }

      num += FLPathSegmentIntersectionCount(modSegment, lineToOutside);
    }

    segment.crossnum = num;
    segment.keep = segment.keep || (num%2 == even ? 0 : 1);
  }
}

+ (void)markUnionOf:(NSArray *)segments
      withModifiers:(NSArray *)segmentsModifier
       outsidePoint:(NSPoint)point
{
  [self markCombinationOf:segments withModifier:segmentsModifier outsidePoint:point even:YES];
}

+ (NSBezierPath *)bezierPathWithSegments:(NSArray *)segments
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  NSPoint points[3];

  if([segments count] == 0) return path;
  
  FLPathSegment *firstSegment = [segments objectAtIndex:0];
  
  NSPoint currentPoint = [firstSegment startPoint];
  [path moveToPoint:currentPoint];
  
  for(int i = 0; i<[segments count]-1; i++) {
    FLPathSegment *segment = [segments objectAtIndex:i];
    [segment points:points];
    [path appendBezierPathWithElement:[segment element] associatedPoints:points];
    currentPoint = [segment endPoint];
  }
  
  FLPathSegment *lastSegment = [segments lastObject];
  if(NSEqualPoints([lastSegment endPoint], [firstSegment startPoint])) {
    [path closePath];
    [path appendBezierPathWithElement:NSClosePathBezierPathElement associatedPoints:NULL];
    [path moveToPoint:[lastSegment endPoint]];
  } else {
    [lastSegment points:points];
    [path appendBezierPathWithElement:[lastSegment element] associatedPoints:points];
  }

  return path;
}

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
@synthesize keep;
@synthesize crossnum;

- (NSBezierPathElement)element
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];

  return 0;
}

- (NSArray *)clipWith:(FLPathSegment *)modifier
{
  return FLPathSegmentIntersections(self, modifier);
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

- (NSPoint)midPoint
{
  CGFloat x = (endPoint.x - startPoint.x) / 2 + startPoint.x;
  CGFloat y = (endPoint.y - startPoint.y) / 2 + startPoint.y;
  
  return NSMakePoint(x,y);
}

- (void)points:(NSPoint *)points
{
  [NSException raise:@"Abstract" format:@"this method must be overridden"];
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
  return [NSString stringWithFormat:@"<%@ startPoint: %@, endPoint: %@, keep: %@>",
          [self className],
          NSStringFromPoint(startPoint),
          NSStringFromPoint(endPoint),
          self.keep ? @"YES" : @"NO"];
}

- (void)points:(NSPoint *)points
{
  points[0] = [self endPoint];
}

- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first
{
  for(int i = 0; i < [intersections count]; i++) {
    NSPoint point = [[intersections objectAtIndex:i] pointValue];

    if(!NSEqualPoints(point, startPoint) && !NSEqualPoints(point, endPoint)) {
      // Line segments that intersect at the start or end point aren't 
      // intersections, but vertexes. TODO test
      CGFloat t = FLLineSegmentLength(startPoint, point) / FLLineSegmentLength(startPoint, endPoint);
      FLIntersection *intersection = [[FLIntersection alloc] initWithPoint:point time:t];
      [[self clippings] addObject:intersection];
    }
  }
}

- (NSArray *)resegment
{
  NSMutableArray *array = [NSMutableArray array];

  [[self clippings] sortUsingSelector:@selector(time)];
  
  NSPoint currentPoint = [self startPoint];
  for(FLIntersection *intersection in [self clippings]) {
    FLPathSegment *nextIntersectionSegment = [FLPathSegment pathSegmentWithStartPoint:currentPoint endPoint:[intersection point]];
    [array addObject:nextIntersectionSegment];
    currentPoint = [intersection point];
  }

  FLPathSegment *lastSegment = [FLPathSegment pathSegmentWithStartPoint:currentPoint endPoint:[self endPoint]];
  [array addObject:lastSegment];
  
  return array;
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
          NSStringFromPoint(endPoint),
          self.keep ? @"YES" : @"NO"];
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
  
  NSArray *intersections = [[NSArray alloc] initWithArray:[self clippings] copyItems:YES]; 
  
  FLPathSegment *remainingSegment = self;
  for(int i = 0; i < [intersections count]; i++) {
    NSPoint points[3];
    FLCurve *splits;
    FLIntersection *intersection = [intersections objectAtIndex:i];

    for(int j = i+1; j < [intersections count]; j++) {
      FLIntersection *furtherIntersection = [intersections objectAtIndex:j];
      [furtherIntersection reprojectWithTime:[intersection time]];
    }
    
    [remainingSegment points:points];
    FLSplitCurveFromPoints([intersection time], [remainingSegment startPoint], points, &splits);
    
    FLPathSegment *newSegment = [FLPathSegment pathSegmentWithStartPoint:splits[0].startPoint points:splits[0].controlPoints];
    [array addObject:newSegment];
    remainingSegment = [FLPathSegment pathSegmentWithStartPoint:splits[1].startPoint points:splits[1].controlPoints];
    free(splits);
  }

  [array addObject:remainingSegment];
  
  return array;
}

@end

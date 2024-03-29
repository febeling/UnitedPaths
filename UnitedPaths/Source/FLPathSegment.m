//
//  FLPathSegment.m
//  UnitedPaths
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegment.h"
#import "FLGeometry.h"
#import "FLIntersection.h"
#import "NSBezierPath+UnitedPathsInternal.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

#pragma mark FLPathSegment

@implementation FLPathSegment

+ (void)clipSegments:(NSMutableArray *)segments modifierSegments:(NSMutableArray *)segmentsModifier
{
  for(FLPathSegment *segmentSelf in segments) {
    for(FLPathSegment *segmentModifier in segmentsModifier) {
      [segmentSelf clipWith:segmentModifier];
    }
  }
  
  [FLPathSegment replaceClippedSegments:segments];
  [FLPathSegment replaceClippedSegments:segmentsModifier];
}

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
    NSUInteger num = 0;
    FLPathSegment *lineToOutside = [FLPathSegment pathSegmentWithStartPoint:[segment midPoint] endPoint:outsidePoint];
    
    NSMutableArray *validCrossingPoints = [NSMutableArray array];

    for(FLPathSegment *modSegment in segmentsModifier) {

      if(even && ([segment isEqual:modSegment] || [segment isCloseToEqual:modSegment])) { // TODO is this special for Union?
        segment.keep = YES;
        break;
      }

      // TODO This function call needs to become a method on this class
      NSArray *newFoundPoints = PathSegmentIntersectionsArray(modSegment, lineToOutside, nil);
      
      // Deduplicate intersection points
      // Note: Double loop, but unlikely to be large.
      for(NSValue *newPoint in newFoundPoints) {
        BOOL seen = NO;
        for(NSValue *knownPoint in validCrossingPoints) {
          if(FLPointsAreClose([newPoint pointValue], [knownPoint pointValue])) {
            seen = YES;
            break;
          }
        }
             
        if(!seen) {
          [validCrossingPoints addObject:newPoint];
        }
      }
      
    }
    num = [validCrossingPoints count];
    
    segment.crossnum = num;
    segment.keep = segment.keep || (num%2 == even ? NO : YES);
  }
}

+ (void)markUnionOf:(NSArray *)segments
      withModifiers:(NSArray *)segmentsModifier
       outsidePoint:(NSPoint)point
{
  [self markCombinationOf:segments withModifier:segmentsModifier outsidePoint:point even:YES];
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

// TODO get rid of isFirst:, which only makes sense for curve segments
- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first // TODO test
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

- (BOOL)isCloseToEqual:(FLPathSegment *)other
{
  return FLPointsAreClose([other startPoint], startPoint) &&
         FLPointsAreClose([other endPoint], endPoint);
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

    if(!FLPointsAreClose(point, startPoint) && !FLPointsAreClose(point, endPoint)) {
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

- (BOOL)isCloseToEqual:(FLPathSegment *)other
{
  return [other isKindOfClass:[self class]] && [super isCloseToEqual:other] ;
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
  return [self initWithStartPoint:theStartPoint
                    controlPoint1:points[0]
                    controlPoint2:points[1]
                         endPoint:points[2]];
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

- (NSPoint)midPoint
{
  NSPoint points[3];
  [self points:points];

  return FLCurvePoint(startPoint, points, 0.5);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@ start: %@, control1: %@, control2: %@, end: %@, keep: %@>",
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

- (BOOL)isCloseToEqual:(FLPathSegment *)other
{
  BOOL result = [super isCloseToEqual:other];
  
  if(result && [other isKindOfClass:[self class]]) {
    FLPathCurveSegment *curve = (FLPathCurveSegment *)other;
    
    return FLPointsAreClose([curve controlPoint1], controlPoint1) &&
           FLPointsAreClose([curve controlPoint2], controlPoint2);
  }
  
  return NO;
}

- (NSUInteger)hash
{
  NSUInteger value = [super hash];
  return value
         ^ NSUINTROTATE([NSStringFromPoint(controlPoint1) hash], 1 * NSUINT_BIT / 3)
         ^ NSUINTROTATE([NSStringFromPoint(controlPoint1) hash], 2 * NSUINT_BIT / 3);
}

- (BOOL)isNewIntersection:(CGFloat)t0
{
  return !FLTimeIsCloseBeginningOrEnd(t0)
      && ([[self clippings] count] == 0
          || !FLFloatIsClose(t0, [(FLIntersection *)[[self clippings] lastObject] time]));
}

// TODO test
- (void)addClippingsWithIntersections:(NSArray *)intersections
                                 info:(NSArray *)info
                              isFirst:(BOOL)first
{
  NSString *timeKey = first ? @"t0" : @"t1";

  for(int i = 0; i < [intersections count]; i++) {
    NSPoint point = [[intersections objectAtIndex:i] pointValue];
    CGFloat t0 = [[[info objectAtIndex:i] objectForKey:timeKey] doubleValue];

    if(![self isNewIntersection:t0]) {
      continue;
    }

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

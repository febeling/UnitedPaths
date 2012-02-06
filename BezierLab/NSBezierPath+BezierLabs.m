//
//  NSBezierPath+BezierLabs.m
//  BezierLab
//
//  Created by Florian Ebeling on 28.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPath+BezierLabs.h"
#import "FLGeometry.h"

// Maximum number of fragments that will be tried to reassemble.
#define MAX_FRAGMENTS 1000

@implementation NSBezierPath (BezierLabs)

- (void)appendBezierPathWithElement:(NSBezierPathElement)element associatedPoints:(NSPointArray)points
{
  switch(element) {
    case NSLineToBezierPathElement:
      [self lineToPoint:points[0]];
      break;
    case NSCurveToBezierPathElement:
      [self curveToPoint:points[2]
           controlPoint1:points[0]
           controlPoint2:points[1]];
      break;
    case NSMoveToBezierPathElement:
      [self moveToPoint:points[0]];
      break;
    case NSClosePathBezierPathElement:
      [self closePath];
      break;
    default:
      [NSException raise:@"Illegal path element" format:@"element id: %dl", element];
  }
}

- (NSPoint)externalPointWithModifier:(NSBezierPath *)modifier
{
  NSRect boundingBox = NSUnionRect([self bounds], [modifier bounds]);

  return NSMakePoint(NSMidX(boundingBox), NSMaxY(boundingBox) + 1.0);
}

- (NSMutableArray *)unionWithBezierPath:(NSBezierPath *)modifier
{
  NSMutableArray *intersections = [NSMutableArray array];
  
  NSMutableArray *segments = [self segments];
  NSMutableArray *segmentsModifier = [modifier segments];
  
  for(FLPathSegment *segmentSelf in segments) {
    for(FLPathSegment *segmentModifier in segmentsModifier) {
      [segmentSelf clipWith:segmentModifier];
    }
  }

  [FLPathSegment replaceClippedSegments:segments];
  [FLPathSegment replaceClippedSegments:segmentsModifier];

  NSPoint outsidePoint = [self externalPointWithModifier:modifier];

  [FLPathSegment markUnionOf:segments withModifiers:segmentsModifier outsidePoint:outsidePoint];
  [FLPathSegment markUnionOf:segmentsModifier withModifiers:segments outsidePoint:outsidePoint];
  
  [segments filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];
  [segmentsModifier filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];
  
  // reassemble point-wise
  
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[segments count]+[segmentsModifier count]];
  for(FLPathSegment *segment in segments) {
    NSValue *key = [NSValue valueWithPoint:[segment startPoint]];
    if([dictionary objectForKey:key]) {
      [NSException raise:@"non-unique start point" format:@"segment: %@", segments];
    }
    [dictionary setObject:segment forKey:key];
  }
  for(FLPathSegment *segment in segmentsModifier) {
    NSValue *key = [NSValue valueWithPoint:[segment startPoint]];
    if([dictionary objectForKey:key]) {
      [NSException raise:@"non-unique start point" format:@"segment: %@", segments];
    }
    [dictionary setObject:segment forKey:key];
  }
  
  // create path from segments
  
  NSMutableArray *unionSegments = [NSMutableArray array];
  
  for(int i = 0; i < MAX_FRAGMENTS; i++) {
    // NEXT
  }
                            
  
  return intersections;
}

- (NSMutableArray *)segments
{
  NSPoint currentPoint;
  NSPoint pathStartPoint;
  
  NSMutableArray *segments = [NSMutableArray array];
  
  for(NSInteger i = 0; i < [self elementCount]; i++) {
    NSPoint points[3];
    NSBezierPathElement element = [self elementAtIndex:i associatedPoints:points];
    
    if(i == 0) {
      pathStartPoint = points[0];
    }

    FLPathSegment *segment;
    
    switch(element) {
      case NSLineToBezierPathElement:
        segment = [[FLPathLineSegment alloc] initWithStartPoint:currentPoint endPoint:points[0]];
        [segments addObject:segment];
        currentPoint = points[0];
        break;
      case NSCurveToBezierPathElement:
        segment = [[FLPathCurveSegment alloc] initWithStartPoint:currentPoint points:points];
        [segments addObject:segment];
        currentPoint = points[2];
        break;
      case NSMoveToBezierPathElement:
        currentPoint = points[0];
        break;
      case NSClosePathBezierPathElement:
        segment = [[FLPathLineSegment alloc] initWithStartPoint:currentPoint endPoint:pathStartPoint];
        [segments addObject:segment];
        break;
      default:
        [NSException raise:@"Illegal path element" format:@"element id: %dl", element];
    }
  }

  return segments;
}

- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier
{
  return nil;
}

@end

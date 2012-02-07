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

- (NSMutableArray *)reassembleSegments:(NSArray *)segments modifier:(NSArray *)segmentsModifier
{
  NSMutableArray *assembled = [NSMutableArray array];

  NSMutableDictionary *segmentByStartPoint = [[segments dictionaryWithKeysUsing:^(id segment) {
    return (id)[NSValue valueWithPoint:[(FLPathSegment *)segment startPoint]];
  }] mutableCopy];
  [segmentByStartPoint addEntriesFromDictionary:[segmentsModifier dictionaryWithKeysUsing:^(id segment) {
    return (id)[NSValue valueWithPoint:[(FLPathSegment *)segment startPoint]];
  }]];
  
  FLPathSegment *nextSegment = [segments objectAtIndex:0];
  [segmentByStartPoint removeObjectForKey:[NSValue valueWithPoint:[nextSegment startPoint]]];
  
  // TODO This algorithm only works when the resulting path is
  //      continuous. Make work for multiple subpaths as well.
  while(nextSegment) {
    [assembled addObject:nextSegment];
    NSValue *key = [NSValue valueWithPoint:[nextSegment endPoint]];
    nextSegment = [segmentByStartPoint objectForKey:key];
    [segmentByStartPoint removeObjectForKey:key];
  }

  return assembled;
}

- (NSMutableArray *)unionWithBezierPath:(NSBezierPath *)modifier
{
  NSMutableArray *intersections = [NSMutableArray array];
  
  NSMutableArray *segments = [self segments];
  NSMutableArray *segmentsModifier = [modifier segments];
  
  for(FLPathSegment *segmentSelf in segments) {
    for(FLPathSegment *segmentModifier in segmentsModifier) {
      [intersections addObjectsFromArray:[segmentSelf clipWith:segmentModifier]];
    }
  }

  [FLPathSegment replaceClippedSegments:segments];
  [FLPathSegment replaceClippedSegments:segmentsModifier];

  NSPoint outsidePoint = [self externalPointWithModifier:modifier];

  [FLPathSegment markUnionOf:segments withModifiers:segmentsModifier outsidePoint:outsidePoint];
  [FLPathSegment markUnionOf:segmentsModifier withModifiers:segments outsidePoint:outsidePoint];

  NSLog(@"segments: %@", segments);
  NSLog(@"modifier: %@", segmentsModifier);
  
  [segments filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];
  [segmentsModifier filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];

  NSMutableArray *unionSegments = [self reassembleSegments:segments modifier:segmentsModifier];
  
  NSLog(@"union segments: %@", unionSegments);
  
  return unionSegments;
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

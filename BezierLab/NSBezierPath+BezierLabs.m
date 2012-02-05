//
//  NSBezierPath+BezierLabs.m
//  BezierLab
//
//  Created by Florian Ebeling on 28.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPath+BezierLabs.h"
#import "FLGeometry.h"

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

- (NSMutableArray *)intersectionsWithBezierPath:(NSBezierPath *)modifier
{
  NSMutableArray *intersections = [NSMutableArray array];
  
  NSMutableArray *segments = [self segments];
  NSMutableArray *segmentsModifier = [modifier segments];
  
  for(FLPathSegment *segmentSelf in segments) {
    for(FLPathSegment *segmentModifier in segmentsModifier) {
      [segmentSelf clipWith:segmentModifier];
    }
  }
  
  // resolve clipping / resegment segments (both)
  
//  NSMutableArray *newSegmentsSelf = [NSMutableArray array];
//  for(FLPathSegment *segment in segments) {
//    [newSegmentSelf addObjectsFromArray:[segment resegement]];
//  }
//
//  NSMutableArray *newSegmentsModifier = [NSMutableArray array];
//  for(FLPathSegment *segment in segmentsModifier) {
//    [newSegmentsModifier addObjectsFromArray:[segment resegement]];
//  }
  
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

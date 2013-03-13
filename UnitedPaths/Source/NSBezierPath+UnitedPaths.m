//
//  NSBezierPath+UnitedPaths.m
//  UnitedPaths
//
//  Created by Florian Ebeling on 28.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSBezierPath+UnitedPaths.h"
#import "FLGeometry.h"
#import "FLPathSegment.h"
#import "NSBezierPath+UnitedPathsInternal.h"

@implementation NSBezierPath (UnitedPaths)

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
  if([lastSegment element] == NSLineToBezierPathElement && NSEqualPoints([lastSegment endPoint], [firstSegment startPoint])) {
    [path closePath];
    [path appendBezierPathWithElement:NSClosePathBezierPathElement associatedPoints:NULL];
    [path moveToPoint:[lastSegment endPoint]];
  } else {
    [lastSegment points:points];
    [path appendBezierPathWithElement:[lastSegment element] associatedPoints:points];
  }

  return path;
}

- (NSBezierPath *)pointPath:(NSPoint)center
{
  CGFloat radius = 2.5;
  NSRect pointRect = NSMakeRect(center.x-radius, center.y-radius, radius*2, radius*2);

  return [NSBezierPath bezierPathWithOvalInRect:pointRect];
}

- (NSArray *)controlPoints
{
  NSPoint points[3];

  NSMutableArray *pathControlPoints = [NSMutableArray array];
  for(int i = 0; i<[self elementCount]; i++) {
    NSBezierPathElement element = [self elementAtIndex:i associatedPoints:points];
    if(NSMoveToBezierPathElement == element || NSLineToBezierPathElement == element) {
      [pathControlPoints addObject:[self pointPath:points[0]]];
    }

    if(NSCurveToBezierPathElement == element) {
      [pathControlPoints addObject:[self pointPath:points[0]]];
      [pathControlPoints addObject:[self pointPath:points[1]]];
      [pathControlPoints addObject:[self pointPath:points[2]]];
    }

    // Closepath doesn't have a point.
  }

  return pathControlPoints;
}

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
      [NSException raise:@"Illegal path element" format:@"element id: %lu", element];
  }
}

- (NSPoint)externalPointWithModifier:(NSBezierPath *)modifier
{
  NSRect boundingBox = NSUnionRect([self bounds], [modifier bounds]);

  // Without some odd coefficient, the test case with two squares side-by-side fails,
  // because the one (de-duplicated) intersection is not recognized as a tangential point.
  CGFloat margin = NSHeight(boundingBox)*M_PI;

  return NSMakePoint(NSMidX(boundingBox), NSMaxY(boundingBox) + margin);
}

- (FLPathSegment *)searchSegmentWithStartPointClose:(NSPoint)point segments:(NSMutableArray *)segments
{
  for(NSUInteger i = 0; i<[segments count]; i++) {
    FLPathSegment *segment = [segments objectAtIndex:i];
    if(FLPointsAreClose(point, [segment startPoint])) {
      [segments removeObjectAtIndex:i];

      return segment;
    }
  }

  return nil;
}

- (NSMutableArray *)reassembleSegments:(NSArray *)segments modifier:(NSArray *)segmentsModifier
{
  NSMutableArray *assembled = [NSMutableArray array];

  NSMutableArray *unassembled = [NSMutableArray array];
  [unassembled addObjectsFromArray:segments];
  [unassembled addObjectsFromArray:segmentsModifier];

  FLPathSegment *nextSegment;
  NSPoint lastEndPoint = [[unassembled objectAtIndex:0] startPoint];

  while((nextSegment = [self searchSegmentWithStartPointClose:lastEndPoint segments:unassembled])) {
    [assembled addObject:nextSegment];
    lastEndPoint = [nextSegment endPoint];
  }

  return assembled;
}

- (NSMutableArray *)unionWithBezierPath:(NSBezierPath *)modifier
{
  NSMutableArray *segments = [self segments];
  NSMutableArray *segmentsModifier = [modifier segments];

  [FLPathSegment clipSegments:segmentsModifier modifierSegments:segments];

  NSPoint outsidePoint = [self externalPointWithModifier:modifier];

  [FLPathSegment markUnionOf:segments withModifiers:segmentsModifier outsidePoint:outsidePoint];
  [FLPathSegment markUnionOf:segmentsModifier withModifiers:segments outsidePoint:outsidePoint];

//  NSLog(@"segments ****");
//  for(id seg in segments) {
//    NSLog(@"%@", seg);
//  }

//  NSLog(@"segmentsModifier ****");
//  for(id seg in segmentsModifier) {
//    NSLog(@"%@", seg);
//  }

  [segments filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];
  [segmentsModifier filterUsingPredicate:[NSPredicate predicateWithFormat:@"keep == YES"]];

  NSMutableArray *unionSegments = [self reassembleSegments:segments modifier:segmentsModifier];

//  NSLog(@"union segments ****");
//  for(id seg in unionSegments) {
//    NSLog(@"%@", seg);
//  }

  return unionSegments;
}

- (NSMutableArray *)segments
{
  NSPoint currentPoint = NSZeroPoint;

  NSMutableArray *segments = [NSMutableArray array];

  for(NSInteger i = 0; i < [self elementCount]; i++) {
    NSPoint points[3];
    NSBezierPathElement element = [self elementAtIndex:i associatedPoints:points];

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
        [self elementAtIndex:0 associatedPoints:points];
        segment = [[FLPathLineSegment alloc] initWithStartPoint:currentPoint endPoint:points[0]];
        [segments addObject:segment];
        break;
      default:
        [NSException raise:@"Illegal path element" format:@"element id: %ld", element];
    }
  }

  return segments;
}

- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier
{
  NSArray *unionSegments = [self unionWithBezierPath:modifier];

  NSBezierPath *bezierPath = [NSBezierPath bezierPathWithSegments:unionSegments];

  return bezierPath;
}

- (BOOL)isEqualToBezierPath:(NSBezierPath *)aPath
{
  if(self == aPath) return YES;
  if([self elementCount] != [aPath elementCount]) return NO;

  NSPoint pointsSelf[3];
  NSPoint pointsOther[3];
  NSUInteger count = [self elementCount];

  for(int i = 0; i<count; i++) {
    NSBezierPathElement elementSelf = [self elementAtIndex:i associatedPoints:pointsSelf];
    NSBezierPathElement elementOther = [aPath elementAtIndex:i associatedPoints:pointsOther];

    if(elementSelf != elementOther) {
      return NO;
    } else {
      if(NSLineToBezierPathElement == elementSelf && !NSEqualPoints(pointsSelf[0], pointsOther[0])) {
        return NO;
      }
      if(NSCurveToBezierPathElement == elementSelf &&
         !(NSEqualPoints(pointsSelf[0], pointsOther[0]) &&
           NSEqualPoints(pointsSelf[1], pointsOther[1]) &&
           NSEqualPoints(pointsSelf[2], pointsOther[2]))) {
        return NO;
      }
      if(NSMoveToBezierPathElement == elementSelf && !NSEqualPoints(pointsSelf[0], pointsOther[0])) {
        return NO;
      }
      // NSClosePathBezierPathElement has not additional information.
    }
  }

  return YES;
}

@end

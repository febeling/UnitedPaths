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

- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier
{
  return nil;
}

@end

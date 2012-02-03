//
//  FLPathSegment.m
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "FLPathSegment.h"

#pragma mark FLPathSegment

@implementation FLPathSegment

- (id)initWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint
{
  self = [super init];
  if(self) {
    startPoint = [NSValue valueWithPoint:theStartPoint];
    endPoint = [NSValue valueWithPoint:theEndPoint];
  }
  
  return self;
}

- (NSBezierPathElement)element
{
  return 0;
}

- (NSPoint)startPoint
{
  return [startPoint pointValue];
}

- (NSPoint)endPoint
{
  return [endPoint pointValue];
}

- (NSUInteger)hash
{
  [NSException raise:@"Not Implemented" format:@"this class does not implement hash for now"];
  // TODO if needed
  
  return 0;
}

- (BOOL)isEqual:(id)other
{
  if(![other isKindOfClass:[self class]]) return NO;
  
  FLPathSegment *otherSegment = (FLPathSegment *)other;
  
  return NSEqualPoints([otherSegment startPoint], self.startPoint) && NSEqualPoints([otherSegment endPoint], self.endPoint);
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
  return [NSString stringWithFormat:@"<%@, startPoint: %@, endPoint: %@>", [self className], startPoint, endPoint];
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
    controlPoint1 = [NSValue valueWithPoint:theControlPoint1];
    controlPoint2 = [NSValue valueWithPoint:theControlPoint2];
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
  return [controlPoint1 pointValue];
}

- (NSPoint)controlPoint2
{
  return [controlPoint2 pointValue];
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

@end

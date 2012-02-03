//
//  FLPathSegment.h
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLPathSegment : NSObject
{
  NSValue *startPoint;
  NSValue *endPoint;
}

@property (readonly) NSBezierPathElement element;
@property (readonly) NSPoint startPoint;
@property (readonly) NSPoint endPoint;

- (id)initWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint;

@end

@interface FLPathLineSegment : FLPathSegment

@end

@interface FLPathCurveSegment : FLPathSegment
{
  NSValue *controlPoint1;
  NSValue *controlPoint2;
}

- (id)initWithStartPoint:(NSPoint)theStartPoint
           controlPoint1:(NSPoint)theControlPoint1
           controlPoint2:(NSPoint)theControlPoint2
                endPoint:(NSPoint)theEndPoint;

- (id)initWithStartPoint:(NSPoint)theStartPoint points:(NSPoint *)points;

@property (readonly) NSPoint controlPoint1;
@property (readonly) NSPoint controlPoint2;

@end


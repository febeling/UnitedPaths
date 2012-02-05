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
  NSPoint startPoint;
  NSPoint endPoint;
  NSMutableArray *clippings;
}

+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint;
+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint points:(NSPoint *)points;
+ (id)pathSegmentWithStartPoint:(NSPoint)theStartPoint
                  controlPoint1:(NSPoint)theControlPoint1
                  controlPoint2:(NSPoint)theControlPoint2
                       endPoint:(NSPoint)theEndPoint;

- (id)initWithStartPoint:(NSPoint)theStartPoint endPoint:(NSPoint)theEndPoint;
- (void)points:(NSPoint *)points;
- (void)clipWith:(FLPathSegment *)modifier;
- (void)addClippingsWithIntersections:(NSArray *)intersections info:(NSArray *)info isFirst:(BOOL)first;

@property (readonly) NSBezierPathElement element;
@property (readonly) NSPoint startPoint;
@property (readonly) NSPoint endPoint;
@property (strong) NSMutableArray *clippings;

@end

@interface FLPathLineSegment : FLPathSegment

@end

@interface FLPathCurveSegment : FLPathSegment
{
  NSPoint controlPoint1;
  NSPoint controlPoint2;
}

- (id)initWithStartPoint:(NSPoint)theStartPoint
           controlPoint1:(NSPoint)theControlPoint1
           controlPoint2:(NSPoint)theControlPoint2
                endPoint:(NSPoint)theEndPoint;
- (id)initWithStartPoint:(NSPoint)theStartPoint points:(NSPoint *)points;

@property (readonly) NSPoint controlPoint1;
@property (readonly) NSPoint controlPoint2;

@end


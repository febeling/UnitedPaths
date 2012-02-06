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

+ (void)replaceClippedSegments:(NSMutableArray *)segments;
+ (void)markCombinationOf:(NSArray *)segments
             withModifier:(NSArray *)modifiers
             outsidePoint:(NSPoint)outsidePoint
                     even:(BOOL)even;
+ (void)markUnionOf:(NSArray *)segments
      withModifiers:(NSArray *)modifiers
       outsidePoint:(NSPoint)point;

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
- (NSArray *)resegment;

@property (readonly) NSBezierPathElement element;
@property (readonly) NSPoint startPoint;
@property (readonly) NSPoint endPoint;
@property (readonly) NSPoint midPoint;
@property (strong) NSMutableArray *clippings;
@property (assign) BOOL keep;

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


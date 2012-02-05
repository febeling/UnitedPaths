//
//  FLIntersection.h
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLPathSegment.h"

@interface FLIntersection : NSObject
{
  NSPoint point;
  CGFloat t;
}

@property (readonly) NSPoint point;
@property (readonly) CGFloat time;

- (id)initWithPoint:(NSPoint)point time:(CGFloat)t;
- (id)initWithPoint:(NSPoint)point;

@end

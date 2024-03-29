//
//  FLIntersection.h
//  UnitedPaths
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLPathSegment.h"

@interface FLIntersection : NSObject <NSCopying>
{
  NSPoint point;
  CGFloat time;
}

@property (readonly) NSPoint point;
@property CGFloat time;

- (id)initWithPoint:(NSPoint)point time:(CGFloat)t;
- (id)initWithPoint:(NSPoint)point;
- (void)reprojectWithTime:(CGFloat)time;

@end

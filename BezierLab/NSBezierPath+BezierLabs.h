//
//  NSBezierPath+BezierLabs.h
//  BezierLab
//
//  Created by Florian Ebeling on 28.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLPathSegment.h"

@interface NSBezierPath (BezierLabs)

- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier;
- (void)appendBezierPathWithElement:(NSBezierPathElement)element associatedPoints:(NSPointArray)points;
- (NSMutableArray *)intersectionsWithBezierPath:(NSBezierPath *)modifier;
- (NSMutableArray *)segments;

@end

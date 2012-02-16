//
//  NSBezierPath+BezierLabs.h
//  BezierLab
//
//  Created by Florian Ebeling on 28.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FLPathSegment;

enum FLPathOperation {
  FLNoPathOperation,
  FLUnionPathOperation,
  FLIntersectionPathOperation
};

@interface NSBezierPath (BezierLabs)

- (NSPoint)externalPointWithModifier:(NSBezierPath *)modifier;
- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier;
- (void)appendBezierPathWithElement:(NSBezierPathElement)element associatedPoints:(NSPointArray)points;
- (NSMutableArray *)unionWithBezierPath:(NSBezierPath *)modifier;
- (NSMutableArray *)segments;
- (BOOL)isEqualToBezierPath:(NSBezierPath *)aPath;

@end

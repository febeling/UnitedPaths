//
//  NSBezierPath+UnitedPathsInternal.h
//  UnitedPaths
//
//  Created by Florian Ebeling on 13.03.13.
//  Copyright (c) 2013 40lines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// These methods are exported here to make testing possible.

@interface NSBezierPath (UnitedPathsInternal)

// Possible public extensions

- (BOOL)isEqualToBezierPath:(NSBezierPath *)aPath;
- (void)appendElement:(NSBezierPathElement)element associatedPoints:(NSPointArray)points;

// Private extensions

+ (NSBezierPath *)bezierPathWithSegments:(NSArray *)segments;
- (NSMutableArray *)segments;
- (NSPoint)externalPointWithModifier:(NSBezierPath *)modifier;
- (NSMutableArray *)unionWithBezierPath:(NSBezierPath *)modifier;

@end

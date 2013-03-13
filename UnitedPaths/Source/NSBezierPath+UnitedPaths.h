//
//  NSBezierPath+UnitedPaths.h
//  UnitedPaths
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

@interface NSBezierPath (UnitedPaths)

- (NSBezierPath *)bezierPathByUnionWith:(NSBezierPath *)modifier;
- (NSArray *)controlPoints;

@end

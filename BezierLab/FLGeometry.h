//
//  FLGeometry.h
//  BezierLab
//
//  Created by Florian Ebeling on 25.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL FLLinePointOnSegment(NSPoint p1, NSPoint p2, NSPoint x);
BOOL FLLineSegmentIntersection(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4, NSPointPointer x);
//
//  TestHelper.h
//  BezierLab
//
//  Created by Florian Ebeling on 06.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#ifndef BezierLab_TestHelper_h
#define BezierLab_TestHelper_h

#define AssertPointsEqualWithAccuracy(P1, P2, D)                  \
{                                                               \
NSPoint __p1 = (P1);                                          \
NSPoint __p2 = (P2);                                          \
STAssertEqualsWithAccuracy(__p1.x, __p2.x, D, @"x of point"); \
STAssertEqualsWithAccuracy(__p1.y, __p2.y, D, @"y of point"); \
}

#endif

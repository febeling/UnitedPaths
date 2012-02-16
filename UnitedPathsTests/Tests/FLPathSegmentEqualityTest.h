//
//  FLPathSegmentEquality.h
//  BezierLab
//
//  Created by Florian Ebeling on 03.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FLPathSegment.h"

@interface FLPathSegmentEqualityTest : SenTestCase
{
  FLPathSegment *one;
  FLPathSegment *other;
}
@end

//
//  BezierLabTests.h
//  BezierLabTests
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSBezierPath+BezierLabs.h"

@interface BezierLabTests : SenTestCase
{
  NSBezierPath *rectPath;
  NSBezierPath *roundedRectPath;
  NSAffineTransform *translation;
}
@end

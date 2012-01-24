//
//  Canvas.h
//  BezierLab
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FLCanvas : NSView
{
  NSArray *shapes;
  NSAffineTransform *translation;
}

@property (strong) NSArray *shapes;

@end

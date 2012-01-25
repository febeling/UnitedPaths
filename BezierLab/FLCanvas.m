//
//  Canvas.m
//  BezierLab
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FLCanvas.h"

@implementation FLCanvas

- (void)setShapes:(NSArray *)array
{
  shapes = array;
  [self setNeedsDisplay:YES];
}

- (NSArray *)shapes
{
  return shapes;
}

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    translation = [NSAffineTransform transform];
    [translation translateXBy:0.5 yBy:0.5];
  }
  
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [NSGraphicsContext saveGraphicsState];
  [translation concat];
  
  [[NSColor colorWithDeviceWhite:0.88 alpha:1.0] set];
  NSRectFill(self.bounds);
  NSDottedFrameRect(self.bounds);
  
  [[NSColor colorWithDeviceWhite:0.4 alpha:0.8] setStroke];
  
  for(id shape in self.shapes) {
    NSColor *color = [shape valueForKey:@"color"];
    [color setFill];
    
    NSBezierPath *path = [shape valueForKey:@"path"];
    [path fill];
    [path stroke];
  }
  
  [NSGraphicsContext restoreGraphicsState];
}

@end

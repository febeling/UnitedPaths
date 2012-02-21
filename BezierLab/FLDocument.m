//
//  FLDocument.m
//  BezierLab
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FLDocument.h"

@implementation FLDocument

@synthesize canvas, shapes;

- (id)init
{
  self = [super init];
  if (self) {
    shapes = [NSMutableArray array];
  }
  return self;
}

- (NSArray *)colorWithIndex:(NSUInteger)index
{
  if(!colors) {
    colors = [NSArray arrayWithObjects:
              [NSColor colorWithDeviceHue:0.594 saturation:0.300 brightness:0.7 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.400 brightness:0.6 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.500 brightness:0.5 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.600 brightness:0.4 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.700 brightness:0.3 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.800 brightness:0.2 alpha:0.9], 
              [NSColor colorWithDeviceHue:0.594 saturation:0.900 brightness:0.1 alpha:0.9], 
              nil];
  }
  
  return [colors objectAtIndex:index];
}

+ (NSSet *)keyPathsForValuesAffectingPathDescription
{
  return [NSSet setWithObject:@"shapes"];
}

- (NSAttributedString *)pathDescription
{
  NSAttributedString *attributedString;
  if([self.shapes count] > 0) {
    NSString *desc = [[self.shapes valueForKey:@"path"] componentsJoinedByString:@"\n"];
    attributedString = [[NSAttributedString alloc] initWithString:desc];
  } else {
    attributedString = [[NSAttributedString alloc] initWithString:@""];
  }
  
  return attributedString;
}

- (void)awakeFromNib
{
  [canvas bind:@"shapes" toObject:self withKeyPath:@"shapes" options:nil];
}

- (NSString *)windowNibName
{
  // Override returning the nib file name of the document
  // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
  return @"FLDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  /*
   Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
   You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
   */
//  NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//  @throw exception;
  return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  /*
   Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
   You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
   If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
   */
//  NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//  @throw exception;
  return YES;
}

+ (BOOL)autosavesInPlace
{
  return YES;
}

#pragma mark Actions

- (IBAction)performUnionOperation:(id)sender
{
  if([self.shapes count] < 2) return;
  
  NSDictionary *first = [self.shapes objectAtIndex:0];
  NSDictionary *second = [self.shapes objectAtIndex:1];
  
  NSMutableDictionary *newShape = [NSMutableDictionary dictionary];
  [newShape setObject:[first objectForKey:@"color"] forKey:@"color"];
  
  NSBezierPath *firstPath = [first objectForKey:@"path"];
  NSBezierPath *secondPath = [second objectForKey:@"path"];
  
  NSBezierPath *newPath = [firstPath bezierPathByUnionWith:secondPath];
  [newShape setObject:newPath forKey:@"path"];
  
  NSMutableArray *newShapeArray = [NSMutableArray array];
  [newShapeArray addObject:newShape];
  [newShapeArray addObjectsFromArray:[self.shapes subarrayWithRange:NSMakeRange(2,[self.shapes count]-2)]];
  
  self.shapes = newShapeArray;
}

- (IBAction)clear:(id)sender;
{
  self.shapes = [NSMutableArray array];
}

- (IBAction)setTwoRectangles:(id)sender;
{
//  NSDictionary *rect1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(100, 100, 200, 100)], @"path",
//                         [self colorWithIndex:1], @"color", nil];
//  NSDictionary *rect2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(150, 150, 200, 100)], @"path",
//                         [self colorWithIndex:4], @"color", nil];
//  
//  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
//  
//  [shapesProxy removeAllObjects];
//  [shapesProxy addObject:rect1];
//  [shapesProxy addObject:rect2];
  
  
  NSBezierPath *p1 = [NSBezierPath bezierPath];
//  71.000000 282.000000 moveto
  [p1 moveToPoint:(NSPoint){71,282}];
//  68.238600 282.000000 66.000000 279.761400 66.000000 277.000000 curveto
  [p1 curveToPoint:NSMakePoint(66.000000, 277.000000) controlPoint1:NSMakePoint(68.238600, 282.000000) controlPoint2:NSMakePoint(66.000000, 279.761400)];
//  66.000000 239.000000 lineto
  [p1 lineToPoint:NSMakePoint(66.000000, 239.000000)];
//  66.000000 236.238600 68.238600 234.000000 71.000000 234.000000 curveto
  [p1 curveToPoint:NSMakePoint(71.000000 , 234.000000) controlPoint1:NSMakePoint(66.000000, 236.238600) controlPoint2:NSMakePoint(68.238600, 234.000000)];
//  90.000000 234.000000 lineto
  [p1 lineToPoint:NSMakePoint(90.000000, 234.000000)];
//  94.000000 234.000000 lineto
  [p1 lineToPoint:NSMakePoint(94.000000, 234.000000)];
//  94.000000 223.000000 lineto
  [p1 lineToPoint:NSMakePoint(94.000000, 223.000000)];
//  94.000000 204.000000 lineto
  [p1 lineToPoint:NSMakePoint(94.000000, 204.000000)];
//  94.000000 185.000000 lineto
  [p1 lineToPoint:NSMakePoint(94.000000, 185.000000)];
//  94.000000 182.238600 96.238600 180.000000 99.000000 180.000000 curveto
  [p1 curveToPoint:NSMakePoint(99.000000 , 180.000000) controlPoint1:NSMakePoint(94.000000, 182.238600) controlPoint2:NSMakePoint(96.238600, 180.000000)];
//  109.000000 180.000000 lineto
  [p1 lineToPoint:NSMakePoint(109.000000, 180.000000)];
//  109.000000 150.000000 lineto
  [p1 lineToPoint:NSMakePoint(109.000000, 150.000000)];
//  142.000000 150.000000 lineto
  [p1 lineToPoint:NSMakePoint(142.000000, 150.000000)];
//  142.000000 185.000000 lineto
  [p1 lineToPoint:NSMakePoint(142.000000, 185.000000)];
//  142.000000 204.000000 lineto
  [p1 lineToPoint:NSMakePoint(142.000000, 204.000000)];
//  142.000000 223.000000 lineto
  [p1 lineToPoint:NSMakePoint(142.000000, 223.000000)];
//  142.000000 234.000000 lineto
  [p1 lineToPoint:NSMakePoint(142.000000, 234.000000)];
//  144.000000 234.000000 lineto
  [p1 lineToPoint:NSMakePoint(144.000000, 234.000000)];
//  163.000000 234.000000 lineto
  [p1 lineToPoint:NSMakePoint(163.000000, 234.000000)];
//  165.761400 234.000000 168.000000 236.238600 168.000000 239.000000 curveto
  [p1 curveToPoint:NSMakePoint(168.000000 , 239.000000) controlPoint1:NSMakePoint(165.761400, 234.000000) controlPoint2:NSMakePoint(168.000000, 236.238600)];
//  168.000000 277.000000 lineto
  [p1 lineToPoint:NSMakePoint(168.000000, 277.000000)];
//  168.000000 279.761400 165.761400 282.000000 163.000000 282.000000 curveto
  [p1 curveToPoint:NSMakePoint(163.000000 , 282.000000) controlPoint1:NSMakePoint(168.000000, 279.761400) controlPoint2:NSMakePoint(165.761400, 282.000000)];
//  144.000000 282.000000 lineto
  [p1 lineToPoint:NSMakePoint(144.000000, 282.000000)];
//  125.000000 282.000000 lineto
  [p1 lineToPoint:NSMakePoint(125.000000, 282.000000)];
//  109.000000 282.000000 lineto
  [p1 lineToPoint:NSMakePoint(109.000000, 282.000000)];
//  90.000000 282.000000 lineto
  [p1 lineToPoint:NSMakePoint(90.000000, 282.000000)];
//  closepath
  [p1 closePath];
//  71.000000 282.000000 moveto

  NSMutableDictionary *shape1 = [NSMutableDictionary dictionary];
  [shape1 setObject:p1 forKey:@"path"];
  [shape1 setObject:[self colorWithIndex:0] forKey:@"color"];
  
  NSMutableArray *theShapes = [self mutableArrayValueForKey:@"shapes"];
  [theShapes removeAllObjects];
  [theShapes addObject:shape1];
  
  NSBezierPath *p2 = [NSBezierPath bezierPath];
  
//  Printing description of obj:
//  114.000000 174.000000 moveto
  [p2 moveToPoint:NSMakePoint(114, 174)];
//  111.238600 174.000000 109.000000 171.761400 109.000000 169.000000 curveto
  [p2 curveToPoint:NSMakePoint(109.000000, 169.000000) controlPoint1:NSMakePoint(111.238600, 174.000000) controlPoint2:NSMakePoint(109.000000, 171.761400)];
//  109.000000 131.000000 lineto
  [p2 lineToPoint:NSMakePoint(109.000000, 131.000000)];
//  109.000000 128.238600 111.238600 126.000000 114.000000 126.000000 curveto
  [p2 curveToPoint:NSMakePoint(114.000000, 126.000000) controlPoint1:NSMakePoint(109.000000, 128.238600) controlPoint2:NSMakePoint(111.238600, 126.000000)];
//  152.000000 126.000000 lineto
  [p2 lineToPoint:NSMakePoint(152.000000, 126.000000)];
//  154.761400 126.000000 157.000000 128.238600 157.000000 131.000000 curveto
  [p2 curveToPoint:NSMakePoint(157.000000, 131.000000) controlPoint1:NSMakePoint(154.761400, 126.000000) controlPoint2:NSMakePoint(157.000000, 128.238600)];
//  157.000000 169.000000 lineto
  [p2 lineToPoint:NSMakePoint(157.000000, 169.000000)];
//  157.000000 171.761400 154.761400 174.000000 152.000000 174.000000 curveto
  [p2 curveToPoint:NSMakePoint(152.000000, 174.000000) controlPoint1:NSMakePoint(157.000000, 171.761400) controlPoint2:NSMakePoint(154.761400, 174.000000)];
//  closepath
  [p2 closePath];
//  114.000000 174.000000 moveto
  
  NSMutableDictionary *shape2 = [NSMutableDictionary dictionary];
  [shape2 setObject:p2 forKey:@"path"];
  [shape2 setObject:[self colorWithIndex:3] forKey:@"color"];
  
  [theShapes addObject:shape2];
}

- (IBAction)setTwoRoundedRectangles:(id)sender;
{
  NSDictionary *rect1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(100, 100, 200, 100)
                                                                                                   xRadius:20
                                                                                                   yRadius:20], @"path",
                         [self colorWithIndex:0], @"color", nil];
  NSDictionary *rect2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(150, 150, 200, 100)
                                                                                                   xRadius:20
                                                                                                   yRadius:20], @"path",
                         [self colorWithIndex:2], @"color", nil];

  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:rect1];
  [shapesProxy addObject:rect2];
}

- (IBAction)setKeyboardShapes:(id)sender
{
  NSMutableArray *newShapes = [NSMutableArray array];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(50, 250, 100, 100)
                                                                                                  xRadius:20
                                                                                                  yRadius:20], @"path",
                        [self colorWithIndex:0], @"color", nil]];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(100, 250, 130, 100)], @"path",
                        [self colorWithIndex:3], @"color", nil]];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(180, 250, 100, 100)
                                                                                                  xRadius:20
                                                                                                  yRadius:20], @"path",
                        [self colorWithIndex:1], @"color", nil]];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(100, 170, 100, 130)], @"path",
                        [self colorWithIndex:4], @"color", nil]];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(100, 120, 100, 100)
                                                                                                  xRadius:20
                                                                                                  yRadius:20], @"path",
                        [self colorWithIndex:2], @"color", nil]];
  
  self.shapes = newShapes;
}

- (IBAction)setFlatnessShapes:(id)sender
{
  NSMutableArray *newShapes = [NSMutableArray array];
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(30,30)];
  [path curveToPoint:NSMakePoint(260,260)
       controlPoint1:NSMakePoint(30,210)
       controlPoint2:NSMakePoint(80,260)];
  [path lineToPoint:NSMakePoint(260,30)];
  [path closePath];
  
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:path, @"path",
                        [self colorWithIndex:0], @"color", nil]];
  
  NSAffineTransform *transform = [NSAffineTransform transform];
  [transform translateXBy:30 yBy:30];
  
  [NSBezierPath setDefaultFlatness:2];
  NSBezierPath *rough = [path bezierPathByFlatteningPath];
  [rough transformUsingAffineTransform:transform];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:rough, @"path",
                        [self colorWithIndex:3], @"color", nil]];
  
  [NSBezierPath setDefaultFlatness:10];
  NSBezierPath *fine = [path bezierPathByFlatteningPath];
  [fine transformUsingAffineTransform:transform];
  [fine transformUsingAffineTransform:transform];
  [newShapes addObject:[NSDictionary dictionaryWithObjectsAndKeys:fine, @"path",
                        [self colorWithIndex:5], @"color", nil]];
  [NSBezierPath setDefaultFlatness:0.6];
  
  self.shapes = newShapes;
}

- (IBAction)setTShapeRectangles:(id)sender
{
  NSDictionary *roof = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(50, 100, 200, 100)], @"path",
                          [self colorWithIndex:1], @"color", nil];
  NSDictionary *trunk = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(100, 50, 100, 50)], @"path",
                          [self colorWithIndex:3], @"color", nil];
  
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:roof];
  [shapesProxy addObject:trunk];
}

- (IBAction)setRoundedRectOverRect:(id)sender
{
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  [shapesProxy removeAllObjects];
  
  [shapesProxy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(30, 140, 200, 100)
                                                                                                  xRadius:20
                                                                                                  yRadius:20], @"path",
                        [self colorWithIndex:0], @"color", nil]];
  [shapesProxy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(130, 140, 200, 100)], @"path",
                        [self colorWithIndex:1], @"color", nil]];
}

- (IBAction)setCircleOverSquareSide:(id)sender
{
  NSDictionary *square = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(50, 50, 150, 150)], @"path",
                          [self colorWithIndex:0], @"color", nil];
  NSDictionary *circle = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(125, 50, 150, 150)], @"path",
                          [self colorWithIndex:2], @"color", nil];
  
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:square];
  [shapesProxy addObject:circle];
}

- (IBAction)setSquareOverCircleCorner:(id)sender
{
  NSDictionary *square = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(70, 145, 150, 150)], @"path",
                          [self colorWithIndex:0], @"color", nil];
  NSDictionary *circle = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(145, 70, 150, 150)], @"path",
                          [self colorWithIndex:2], @"color", nil];
  
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:square];
  [shapesProxy addObject:circle];
}

- (IBAction)setSquareOverCircleSide:(id)sender
{
  NSDictionary *circle = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(50, 50, 150, 150)], @"path",
                          [self colorWithIndex:1], @"color", nil];
  NSDictionary *square = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(50, 125, 150, 150)], @"path",
                          [self colorWithIndex:4], @"color", nil];
  
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:circle];
  [shapesProxy addObject:square];
}

- (IBAction)setSquareNextToSquare:(id)sender
{
  NSDictionary *square = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(70, 100, 150, 150)], @"path",
                          [self colorWithIndex:4], @"color", nil];
  NSDictionary *square2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(145, 100, 150, 150)], @"path",
                          [self colorWithIndex:5], @"color", nil];
  
  NSMutableArray *shapesProxy = [self mutableArrayValueForKey:@"shapes"];
  
  [shapesProxy removeAllObjects];
  [shapesProxy addObject:square];
  [shapesProxy addObject:square2];
}

@end

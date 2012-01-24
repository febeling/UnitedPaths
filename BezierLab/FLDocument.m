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
    // Add your subclass-specific initialization here.
    // If an error occurs here, return nil.
  }
  return self;
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

- (IBAction)setAndOperation:(id)sender;
{
  
}

- (IBAction)resetOperation:(id)sender;
{
  
}


- (IBAction)setTwoRectangles:(id)sender;
{
  NSDictionary *rect1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(100, 100, 200, 100)], @"path",
                         [NSColor redColor], @"color",
                         nil];
  NSDictionary *rect2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRect:NSMakeRect(150, 150, 200, 100)], @"path",
                         [NSColor blueColor], @"color",
                         nil];
  self.shapes = [NSArray arrayWithObjects:rect1, rect2, nil];
}

- (IBAction)setTwoRoundedRectangles:(id)sender;
{
  NSDictionary *rect1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(100, 100, 200, 100)
                                                                                                   xRadius:20
                                                                                                   yRadius:20], @"path",
                         [NSColor redColor], @"color",
                         nil];
  NSDictionary *rect2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(150, 150, 200, 100)
                                                                                                   xRadius:20
                                                                                                   yRadius:20], @"path",
                         [NSColor blueColor], @"color",
                         nil];
  self.shapes = [NSArray arrayWithObjects:rect1, rect2, nil];

}

- (IBAction)clear:(id)sender;
{
  self.shapes = [NSArray array];
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
  NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
  @throw exception;
  return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  /*
   Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
   You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
   If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
   */
  NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
  @throw exception;
  return YES;
}

+ (BOOL)autosavesInPlace
{
  return YES;
}

@end

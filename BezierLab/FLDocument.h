//
//  FLDocument.h
//  BezierLab
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLCanvas.h"

@interface FLDocument : NSDocument
{
  FLCanvas *canvas;
  NSArray *shapes;
  NSArray *colors;
}

- (IBAction)setAndOperation:(id)sender;
- (IBAction)resetOperation:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)setTwoRectangles:(id)sender;
- (IBAction)setTwoRoundedRectangles:(id)sender;
- (IBAction)setKeyboardShapes:(id)sender;
- (IBAction)setFlatnessShapes:(id)sender;

@property (strong) IBOutlet FLCanvas *canvas;
@property (strong) NSArray *shapes;
@property (readonly) NSAttributedString *pathDescription;

@end

//
//  FLDocument.h
//  BezierLab
//
//  Created by Florian Ebeling on 24.01.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLCanvas.h"
#import "UnitedPaths/NSBezierPath+BezierLabs.h"

@interface FLDocument : NSDocument
{
  FLCanvas *canvas;
  NSMutableArray *shapes;
  NSArray *colors;
}

- (IBAction)performUnionOperation:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)setTwoRectangles:(id)sender;
- (IBAction)setTwoRoundedRectangles:(id)sender;
- (IBAction)setKeyboardShapes:(id)sender;
- (IBAction)setFlatnessShapes:(id)sender;
- (IBAction)setTShapeRectangles:(id)sender;
- (IBAction)setRoundedRectOverRect:(id)sender;
- (IBAction)setCircleOverSquareSide:(id)sender;
- (IBAction)setSquareOverCircleCorner:(id)sender;
- (IBAction)setSquareOverCircleSide:(id)sender;
- (IBAction)setSquareNextToSquare:(id)sender;

@property (strong) IBOutlet FLCanvas *canvas;
@property (strong) NSMutableArray *shapes;
@property (readonly) NSAttributedString *pathDescription;

@end

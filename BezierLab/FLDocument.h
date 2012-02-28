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
  NSMutableArray *shapes;
  BOOL showControlPoints;
  
  FLCanvas *canvas;
  NSArray *colors;
}

- (IBAction)performUnionOperation:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)setTwoRectangles:(id)sender;
- (IBAction)setTwoRoundedRectangles:(id)sender;
- (IBAction)setKeyboardShapes:(id)sender;
- (IBAction)setFlatnessShapes:(id)sender;
- (IBAction)setTShapeRectangles:(id)sender;
- (IBAction)setRectNextToRoundedRect:(id)sender;
- (IBAction)setCircleOverSquareSide:(id)sender;
- (IBAction)setSquareOverCircleCorner:(id)sender;
- (IBAction)setSquareOverCircleSide:(id)sender;
- (IBAction)setSquareNextToSquare:(id)sender;
- (IBAction)setSquareAtopSquare:(id)sender;
- (IBAction)setRoundedRectangleOverCornerOfRectangle:(id)sender;

@property (strong) IBOutlet FLCanvas *canvas;
@property (strong) NSMutableArray *shapes;
@property (assign) BOOL showControlPoints;
@property (readonly) NSAttributedString *pathDescription;
@property (readonly) NSArray *controlPoints;

@end

//
//  NSArray+CreateDictionaryUsingBlock.h
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CreateDictionaryUsingBlock)

- (NSDictionary *)dictionaryWithKeysUsing:(id (^)(id obj))block;

@end

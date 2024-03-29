//
//  NSArray+CreateDictionaryUsingBlock.h
//  UnitedPaths
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSArray (CreateDictionaryUsingBlock)

- (NSDictionary *)dictionaryWithKeysUsing:(id (^)(id obj))block;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

@end

//
//  NSArray+CreateDictionaryUsingBlock.m
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSArray+CreateDictionaryUsingBlock.h"

@implementation NSArray (CreateDictionaryUsingBlock)

- (NSDictionary *)dictionaryWithKeysUsing:(id (^)(id obj))block
{
  NSUInteger n = [self count];
  __autoreleasing id *keys = (__autoreleasing id *)malloc(n*sizeof(id));
  __autoreleasing id *objects = (__autoreleasing id *)malloc(n*sizeof(id));
  
  for(int i = 0; i<n; i++) {
    id object = [self objectAtIndex:i];
    keys[i] = block(object);
    objects[i] = object;
  }
  
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:n];
  
  free(keys);
  free(objects);
  
  return dictionary;
}

@end

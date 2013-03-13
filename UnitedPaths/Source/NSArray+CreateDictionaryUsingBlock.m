//
//  NSArray+CreateDictionaryUsingBlock.m
//  UnitedPaths
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSArray+CreateDictionaryUsingBlock.h"

@implementation NSArray (CreateDictionaryUsingBlock)

- (NSDictionary *)dictionaryWithKeysUsing:(id (^)(id obj))block
{
  NSUInteger n = [self count];
  __strong id *keys = (__strong id *)calloc(sizeof(id), n);
  __strong id *objects = (__strong id *)calloc(sizeof(id), n);

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

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
  NSArray *keys = [self valueForKey:key];
  
  return [NSDictionary dictionaryWithObjects:self forKeys:keys];
}

@end

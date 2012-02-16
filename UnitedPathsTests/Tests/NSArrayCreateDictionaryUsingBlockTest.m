//
//  NSArrayCreateDictionaryUsingBlock.m
//  BezierLab
//
//  Created by Florian Ebeling on 07.02.12.
//  Copyright (c) 2012 40lines. All rights reserved.
//

#import "NSArrayCreateDictionaryUsingBlockTest.h"
#import "NSArray+CreateDictionaryUsingBlock.h"

@implementation NSArrayCreateDictionaryUsingBlockTest

- (void)testCreateDictionaryUsingBlock
{
  NSArray *array = [NSArray arrayWithObjects:@"a", @"bb", @"ccc", nil];
  
  NSDictionary *dictionary = [array dictionaryWithKeysUsing:^(id object) { return (id)[NSNumber numberWithUnsignedInteger:[object length]]; }];
  
  NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"a", [NSNumber numberWithUnsignedInteger:1ul],
                            @"bb", [NSNumber numberWithUnsignedInteger:2ul],
                            @"ccc", [NSNumber numberWithUnsignedInteger:3ul], nil];
  
  STAssertEqualObjects(dictionary, expected, nil);
}

- (void)testDictionaryByValueForKey
{
  NSArray *foo = [NSDictionary dictionaryWithObject:@"foo" forKey:@"name"];
  NSArray *bar = [NSDictionary dictionaryWithObject:@"bar" forKey:@"name"];
  NSArray *baz = [NSDictionary dictionaryWithObject:@"baz" forKey:@"name"];
  NSArray *array = [NSArray arrayWithObjects:foo, bar, baz, nil];

  NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                            foo, @"foo",
                            bar, @"bar", 
                            baz, @"baz", nil];
  
  STAssertEqualObjects([array dictionaryForKey:@"name"], expected, nil);
}

@end

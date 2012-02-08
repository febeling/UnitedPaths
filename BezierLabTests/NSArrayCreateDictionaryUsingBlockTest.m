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

@end

//
//  P2LLaTex2XmlTests.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 29.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LLaTex2XmlTests.h"

@implementation P2LLaTex2XmlTests

- (void)testSquareRoot
{
    NSString *searchText = @"\\sqrt[3]{\\frac{a}{b}} \\quad \\sqrt{\\frac{a}{b}}";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\\\sqrt\\[([0-9])\\]\\{"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText
                                                       options:0
                                                         range:NSMakeRange(0, [searchText length])
                                                  withTemplate:@"\\\\msqrt{$1}{"];
    
    
    
    NSLog(@"%@", searchText);
    NSLog(@"%@", result);
    
    STAssertEqualObjects(result, @"\\msqrt{3}{\\frac{a}{b}} \\quad \\sqrt{\\frac{a}{b}}", @"square root conversion");
}

@end

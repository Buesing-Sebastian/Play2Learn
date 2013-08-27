//
//  P2LQTISectionImporter.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LQTISectionImporter.h"
#import "P2LQTIAssessmentItemImporter.h"

@implementation P2LQTISectionImporter

+ (void)importAssessmentSectionUsingDictionary:(NSDictionary *)sectionDictionary andCatalog:(Catalog *)catalog
{
    NSString *identifier = [sectionDictionary objectForKey:@"identifier"];
    
    if (identifier)
    {
        identifier = [identifier stringByReplacingOccurrencesOfString:@"section" withString:@""];
        
        Lesson *lesson = (Lesson *)[Lesson findModelWithPrimaryKey:[identifier intValue]];
        
        if (!lesson)
        {
            lesson = [[Lesson alloc] initEntity];
        }
        NSDictionary *rubricBlock = [sectionDictionary objectForKey:@"rubricBlock"];
        
        if (rubricBlock)
        {
            lesson.name = [rubricBlock objectForKey:@"text"];
        }
        else
        {
            NSLog(@"Error: no rubicBlock found for assessmentSection!");
        }
        lesson.catalog = catalog;
        
        NSObject *assessmentItemRef = [sectionDictionary objectForKey:@"assessmentItemRef"];
        
        if ([assessmentItemRef isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictionary in (NSArray *)assessmentItemRef)
            {
                [P2LQTIAssessmentItemImporter importAssessmentItemRefUsingDictionary:dictionary intoLesson:lesson];
            }
        }
        else if ([assessmentItemRef isKindOfClass:[NSDictionary class]])
        {
            [P2LQTIAssessmentItemImporter importAssessmentItemRefUsingDictionary:(NSDictionary *)assessmentItemRef intoLesson:lesson];
        }
        else
        {
            NSLog(@"Error: AssessmentSection has no AssessmentItemRef");
        }
        
        [lesson save];
    }
    else
    {
        NSLog(@"Error: No identifier found on AssessmentSection");
    }
}

@end

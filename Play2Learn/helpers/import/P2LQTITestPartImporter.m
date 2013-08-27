//
//  P2LQTITestPartImporter.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LQTITestPartImporter.h"
#import "P2LQTISectionImporter.h"
#import "P2LModelManager.h"

@implementation P2LQTITestPartImporter

+ (void)importTestUsingDictionary:(NSDictionary *)testPartDictionary andCatalog:(Catalog *)catalog
{
    if (testPartDictionary)
    {
        NSObject *assessmentSection = [testPartDictionary objectForKey:@"assessmentSection"];
        
        if ([assessmentSection isKindOfClass:[NSArray class]])
        {
            NSArray *sectionArray = (NSArray *)assessmentSection;
            
            for (NSDictionary *sectionDictionary in sectionArray)
            {
                [P2LQTISectionImporter importAssessmentSectionUsingDictionary:sectionDictionary andCatalog:catalog];
            }
        }
        else if ([assessmentSection isKindOfClass:[NSDictionary class]])
        {
            [P2LQTISectionImporter importAssessmentSectionUsingDictionary:(NSDictionary *)assessmentSection andCatalog:catalog];
        }
        else
        {
            NSLog(@"Error: no assessmentSection found!");
        }
        // save any unsaved changes.
        NSError *error;
        [[P2LModelManager currentContext] save:&error];
    }
    else
    {
        NSLog(@"Error: nil argument given!");
    }
}


@end

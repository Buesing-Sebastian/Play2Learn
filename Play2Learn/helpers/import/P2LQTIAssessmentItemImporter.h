//
//  P2LQTIAssessmentItemImporter.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 02.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lesson+DBAPI.h"

@interface P2LQTIAssessmentItemImporter : NSObject

+ (void)importAssessmentItemRefUsingDictionary:(NSDictionary *)dictionary intoLesson:(Lesson *)lesson;


@end

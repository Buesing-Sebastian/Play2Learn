//
//  Lesson.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catalog, Question;

@interface Lesson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t primaryKey;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) Catalog *catalog;
@end

@interface Lesson (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end

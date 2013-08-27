//
//  Inquiry.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Choice, Conquest, Lesson, Question;

@interface Inquiry : NSManagedObject

@property (nonatomic, retain) NSString * answers;
@property (nonatomic) NSTimeInterval finished;
@property (nonatomic) int32_t primaryKey;
@property (nonatomic) NSTimeInterval started;
@property (nonatomic) float score;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) Lesson *lesson;
@property (nonatomic, retain) Conquest *usedInConquest;
@property (nonatomic, retain) NSSet *choices;
@end

@interface Inquiry (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

- (void)addChoicesObject:(Choice *)value;
- (void)removeChoicesObject:(Choice *)value;
- (void)addChoices:(NSSet *)values;
- (void)removeChoices:(NSSet *)values;

@end

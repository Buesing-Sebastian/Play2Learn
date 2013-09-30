//
//  Inquiry.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 29.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Choice, Conquest, Lesson, Question;

@interface Inquiry : NSManagedObject

@property (nonatomic) NSTimeInterval finished;
@property (nonatomic) float score;
@property (nonatomic) NSTimeInterval started;
@property (nonatomic, retain) NSSet *choices;
@property (nonatomic, retain) Lesson *lesson;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) Conquest *usedInConquest;
@end

@interface Inquiry (CoreDataGeneratedAccessors)

- (void)addChoicesObject:(Choice *)value;
- (void)removeChoicesObject:(Choice *)value;
- (void)addChoices:(NSSet *)values;
- (void)removeChoices:(NSSet *)values;

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end

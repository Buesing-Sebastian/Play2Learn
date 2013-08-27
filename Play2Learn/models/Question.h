//
//  Question.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Lesson.h"
#import "Answer.h"


@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * prompt;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * primaryKey;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) NSSet *correctAnswers;
@property (nonatomic, retain) Lesson *lesson;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

- (void)addCorrectAnswersObject:(Answer *)value;
- (void)removeCorrectAnswersObject:(Answer *)value;
- (void)addCorrectAnswers:(NSSet *)values;
- (void)removeCorrectAnswers:(NSSet *)values;

@end

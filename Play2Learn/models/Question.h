//
//  Question.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 29.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Choice, Inquiry, Lesson;

@interface Question : NSManagedObject

@property (nonatomic) int16_t difficulty;
@property (nonatomic, retain) NSString * primaryKey;
@property (nonatomic, retain) NSString * prompt;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) NSSet *choices;
@property (nonatomic, retain) NSSet *correctAnswers;
@property (nonatomic, retain) NSSet *inquiries;
@property (nonatomic, retain) Lesson *lesson;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

- (void)addChoicesObject:(Choice *)value;
- (void)removeChoicesObject:(Choice *)value;
- (void)addChoices:(NSSet *)values;
- (void)removeChoices:(NSSet *)values;

- (void)addCorrectAnswersObject:(Answer *)value;
- (void)removeCorrectAnswersObject:(Answer *)value;
- (void)addCorrectAnswers:(NSSet *)values;
- (void)removeCorrectAnswers:(NSSet *)values;

- (void)addInquiriesObject:(Inquiry *)value;
- (void)removeInquiriesObject:(Inquiry *)value;
- (void)addInquiries:(NSSet *)values;
- (void)removeInquiries:(NSSet *)values;

@end

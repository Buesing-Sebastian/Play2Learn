//
//  Answer.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 28.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Choice, Question;

@interface Answer : NSManagedObject

@property (nonatomic) int64_t primaryKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *choices;
@property (nonatomic, retain) Question *correctAnswerToQuestion;
@property (nonatomic, retain) Question *question;
@end

@interface Answer (CoreDataGeneratedAccessors)

- (void)addChoicesObject:(Choice *)value;
- (void)removeChoicesObject:(Choice *)value;
- (void)addChoices:(NSSet *)values;
- (void)removeChoices:(NSSet *)values;

@end

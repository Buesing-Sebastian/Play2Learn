//
//  Answer.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Choice, Question;

@interface Answer : NSManagedObject

@property (nonatomic) int64_t primaryKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Question *question;
@property (nonatomic, retain) Choice *choices;
@property (nonatomic, retain) Question *correctAnswerToQuestion;

@end

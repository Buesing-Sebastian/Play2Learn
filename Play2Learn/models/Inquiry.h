//
//  Inquiry.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Inquiry : NSManagedObject

@property (nonatomic, retain) NSDate *started;
@property (nonatomic, retain) NSDate *finished;
@property (nonatomic, retain) NSString *answers;
@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSSet *questions;
@end

@interface Inquiry (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end

//
//  Lesson.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 29.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catalog, Conquest, Inquiry, Question;

@interface Lesson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * primaryKey;
@property (nonatomic, retain) Catalog *catalog;
@property (nonatomic, retain) NSSet *conquests;
@property (nonatomic, retain) NSSet *inquiries;
@property (nonatomic, retain) NSSet *questions;
@end

@interface Lesson (CoreDataGeneratedAccessors)

- (void)addConquestsObject:(Conquest *)value;
- (void)removeConquestsObject:(Conquest *)value;
- (void)addConquests:(NSSet *)values;
- (void)removeConquests:(NSSet *)values;

- (void)addInquiriesObject:(Inquiry *)value;
- (void)removeInquiriesObject:(Inquiry *)value;
- (void)addInquiries:(NSSet *)values;
- (void)removeInquiries:(NSSet *)values;

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end

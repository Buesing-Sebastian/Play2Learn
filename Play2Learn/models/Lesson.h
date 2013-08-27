//
//  Lesson.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catalog, Inquiry, Question;

@interface Lesson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t primaryKey;
@property (nonatomic, retain) Catalog *catalog;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) NSSet *inquiries;
@property (nonatomic, retain) NSManagedObject *conquered;
@end

@interface Lesson (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

- (void)addInquiriesObject:(Inquiry *)value;
- (void)removeInquiriesObject:(Inquiry *)value;
- (void)addInquiries:(NSSet *)values;
- (void)removeInquiries:(NSSet *)values;

@end

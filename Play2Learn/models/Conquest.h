//
//  Conquest.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inquiry, Lesson;

@interface Conquest : NSManagedObject

@property (nonatomic) BOOL finished;
@property (nonatomic, retain) NSSet *inquiries;
@property (nonatomic, retain) Lesson *lesson;
@end

@interface Conquest (CoreDataGeneratedAccessors)

- (void)addInquiriesObject:(Inquiry *)value;
- (void)removeInquiriesObject:(Inquiry *)value;
- (void)addInquiries:(NSSet *)values;
- (void)removeInquiries:(NSSet *)values;

@end

//
//  Catalog.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lesson;

@interface Catalog : NSManagedObject

@property (nonatomic, retain) NSString * href;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t primaryKey;
@property (nonatomic, retain) NSSet *lessons;
@end

@interface Catalog (CoreDataGeneratedAccessors)

- (void)addLessonsObject:(Lesson *)value;
- (void)removeLessonsObject:(Lesson *)value;
- (void)addLessons:(NSSet *)values;
- (void)removeLessons:(NSSet *)values;

@end

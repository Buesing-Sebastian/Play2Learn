//
//  Catalog.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lesson;

@interface Catalog : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int32_t primaryKey;
@property (nonatomic, retain) NSString *href;
@property (nonatomic, retain) NSSet *lessons;

@end

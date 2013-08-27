//
//  P2LModelManager.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2LDBAPIProtocol.h"

@interface P2LModelManager : NSObject

+ (NSManagedObject<P2LDBAPIProtocol>*)findModel:(int)primaryId ofEntityType:(NSString *)entityType;

+ (int)saveModel:(NSManagedObject<P2LDBAPIProtocol>*)model;

+ (void)deleteModel:(NSManagedObject<P2LDBAPIProtocol>*)model;

+ (NSManagedObjectContext *)currentContext;

+ (NSArray *)getAllEntitiesWithName:(NSString *)entityName;

@end

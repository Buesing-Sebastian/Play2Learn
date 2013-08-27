//
//  P2LDBAPIProtocol.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol P2LDBAPIProtocol <NSObject>

@required

/**
 * Initializes the entity into the NSMangedObjectContext.
 */
- (id)initEntity;

/**
 *  Returns the primaryKey of the model as an int.
 */
- (int)primaryId;

/**
 *  Sets the primaryKey of the model with a given int value.
 */
- (void)setPrimaryId:(int)primaryId;

/**
 * Returns the entity name of the model.
 */
+ (NSString *)entityName;

/**
 * looks into the DB for the given model and loads the object with given 
 * primary key.
 */
+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey;

/**
 * Saves instance of the model. If it has no primary key, than one is generated and stored
 * in the DB. Always returns the primary key.
 */
- (int)save;

/**
 * Deletes the model from the DB.
 */
- (void)deleteModel;

@end

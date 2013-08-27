//
//  Lesson+DBAPI.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Lesson+DBAPI.h"
#import "P2LModelManager.h"

@implementation Lesson (DBAPI)

- (id)initEntity
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Lesson" inManagedObjectContext:context];
    
    return [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey
{
    return [P2LModelManager findModel:primaryKey ofEntityType:[self entityName]];
}

+ (NSString *)entityName
{
    return @"Lesson";
}

- (int)save
{
    return [P2LModelManager saveModel:self];
}

- (void)deleteModel
{
    [P2LModelManager deleteModel:self];
}

- (void)didSave
{
    if ([self primaryId] == 0)
    {
        [self save];
    }
}

- (int)primaryId
{
    return self.primaryKey;
}

- (void)setPrimaryId:(int)primaryId
{
    [self setPrimaryKey:primaryId];
}

@end

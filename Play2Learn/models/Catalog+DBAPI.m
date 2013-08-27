//
//  Catalog+DBAPI.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Catalog+DBAPI.h"
#import "P2LModelManager.h"

@implementation Catalog (DBAPI)

- (id)initEntity
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Catalog" inManagedObjectContext:context];
    
    return [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey
{
    return [P2LModelManager findModel:primaryKey ofEntityType:[self entityName]];
}

+ (NSString *)entityName
{
    return @"Catalog";
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

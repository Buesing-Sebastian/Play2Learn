//
//  Answer+DBAPI.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Answer+DBAPI.h"
#import "P2LModelManager.h"

@implementation Answer (DBAPI)

- (id)initEntity
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:context];
    
    return [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey
{
    return [P2LModelManager findModel:primaryKey ofEntityType:[self entityName]];
}

+ (NSString *)entityName
{
    return @"Answer";
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
    return [self.primaryKey intValue];
}

- (void)setPrimaryId:(int)primaryId
{
    [self setPrimaryKey:[NSNumber numberWithInt:primaryId]];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Answer: (%d){\n", self.primaryId];
    
    desc = [desc stringByAppendingFormat:@" text: %@", self.text];
    desc = [desc stringByAppendingFormat:@"}\n"];
    
    return desc;
}

@end

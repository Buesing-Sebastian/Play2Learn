//
//  Question+DBAPI.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Question+DBAPI.h"
#import "P2LModelManager.h"

@implementation Question (DBAPI)

- (id)initEntity
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
    
    return [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey
{
    return [P2LModelManager findModel:primaryKey ofEntityType:[self entityName]];
}

+ (NSString *)entityName
{
    return @"Question";
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
    NSString *desc = [NSString stringWithFormat:@"Question: (%d){\n", self.primaryId];
    
    NSArray *array = [self.answers allObjects];
    
    desc = [desc stringByAppendingFormat:@" - answers {\n"];
    
    for (int i = 0; i < [array count]; i++)
    {
        Answer *answer = [array objectAtIndex:i];
        
        desc = [desc stringByAppendingFormat:@"%d: %@\n", i, answer];
    }
    desc = [desc stringByAppendingFormat:@"}\n"];
    
    
    array = [self.correctAnswers allObjects];
    
    desc = [desc stringByAppendingFormat:@" - correct answers {\n"];
    
    for (int i = 0; i < [array count]; i++)
    {
        Answer *answer = [array objectAtIndex:i];
        
        desc = [desc stringByAppendingFormat:@"%d: %@\n", i, answer];
    }
    desc = [desc stringByAppendingFormat:@"}\n}\n"];
    
    return desc;
}

@end

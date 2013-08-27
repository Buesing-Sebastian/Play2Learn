//
//  P2LModelManager.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LModelManager.h"
#import "P2LAppDelegate.h"
#import "PrimaryKey.h"
#import "Question.h"
#import "Answer.h"
#import "Lesson.h"
#import "Inquiry.h"
#import "Catalog.h"

@implementation P2LModelManager

+ (NSManagedObject<P2LDBAPIProtocol>*)findModel:(int)primaryId ofEntityType:(NSString *)entityType
{
    NSManagedObjectContext *context = [self currentContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"primaryKey == %d", primaryId];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityType
                                              inManagedObjectContext:context];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] == 0 || error != nil)
    {
        return nil;
    }
    else
    {
        return [results objectAtIndex:0];
    }
}

+ (int)saveModel:(NSManagedObject<P2LDBAPIProtocol>*)model
{
    if ([model primaryId] == 0)
    {
        model.primaryId = [self primaryIdForEntity:model];
    }
    NSManagedObjectContext *context = [self currentContext];
    
    NSError *error;
    [context save:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
        return 0;
    }
    else
    {
        return model.primaryId;
    }
}

+ (void)deleteModel:(NSManagedObject<P2LDBAPIProtocol>*)model
{
    [[self currentContext] deleteObject:model];
}

+ (int)primaryIdForEntity:(NSManagedObject<P2LDBAPIProtocol>*)model
{
    NSManagedObjectContext *context = [self currentContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PrimaryKey"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];

    PrimaryKey *primary;
    
    if ([results count] == 0)
    {
        primary = [NSEntityDescription insertNewObjectForEntityForName:@"PrimaryKey"
                                                inManagedObjectContext:context];
        primary.question = 0;
        primary.answer = 0;
        primary.lesson = 0;
        primary.inquiry = 0;
        
        [context save:&error];
    }
    else
    {
        primary = [results objectAtIndex:0];
    }
    
    int primaryId = 0;
    
    if ([model isKindOfClass:[Question class]])
    {
        primaryId = ++primary.question;
    }
    if ([model isKindOfClass:[Catalog class]])
    {
        primaryId = ++primary.catalog;
    }
    else if ([model isKindOfClass:[Answer class]])
    {
        primaryId = ++primary.answer;
    }
    else if ([model isKindOfClass:[Lesson class]])
    {
        primaryId = ++primary.lesson;
    }
    else if ([model isKindOfClass:[Inquiry class]])
    {
        primaryId = ++primary.inquiry;
    }
    //[context save:&error];
    
    return primaryId;
}

+ (NSManagedObjectContext *)currentContext
{
    P2LAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

+ (NSArray *)getAllEntitiesWithName:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:[P2LModelManager currentContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[P2LModelManager currentContext] executeFetchRequest:fetchRequest error:&error];
    
    return items;
}

@end

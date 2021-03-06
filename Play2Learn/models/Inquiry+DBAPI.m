//
//  Inquiry+DBAPI.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Inquiry+DBAPI.h"
#import "P2LModelManager.h"

@implementation Inquiry (DBAPI)

- (id)initEntity
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Inquiry" inManagedObjectContext:context];
    
    return [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

+ (NSManagedObject *)findModelWithPrimaryKey:(int)primaryKey
{
    return [P2LModelManager findModel:primaryKey ofEntityType:[self entityName]];
}

+ (NSString *)entityName
{
    return @"Inquiry";
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

+ (NSArray *)allInquiriesForCatalog:(Catalog *)catalog
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"started" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lesson.catalog.primaryKey = %d", catalog.primaryKey]];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [[P2LModelManager currentContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"muh!");
    }
    
    return result;
}

- (NSString *)timeSpanStringUsingFormat:(NSString *)formatString
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.started];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.finished];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    
    NSString *startString = [format stringFromDate:startDate];
    NSString *endString = [format stringFromDate:endDate];
    
    int diffInSeconds = self.finished - self.started;
    
    NSString *spanString;
    
    if (diffInSeconds <= 60)
    {
        spanString = [NSString stringWithFormat:@"%d Sekunden", diffInSeconds];
    }
    else
    {
        spanString = [NSString stringWithFormat:@"%d Minuten", (int)((float)diffInSeconds / 60.0f)];
    }
    
    return [NSString stringWithFormat:@"%@ - %@  (%@)", startString, endString, spanString];
}

@end

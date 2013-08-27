//
//  P2LQTIImporter.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LQTIImporter.h"
#import "XMLReader.h"
#import "P2LQTITestPartImporter.h"
#import "P2LModelManager.h"
#import "Answer+DBAPI.h"
#import "Lesson+DBAPI.h"
#import "Question+DBAPI.h"

@interface P2LQTIImporter ()

@end

@implementation P2LQTIImporter

+ (void)importDataForCatalog:(Catalog *)catalog
{
    NSData *data;
    
    if ([catalog.href isEqualToString:@""])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Testdatei" ofType:@"xml"];
        data = [NSData dataWithContentsOfFile:filePath];
    }
    else
    {
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:[catalog.href stringByAppendingString:@"catalog.xml"]] encoding:NSUTF8StringEncoding error:nil];
        data = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self parseData:data withCatalog:catalog];
}

+ (void)importDataFromURL:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self parseData:data withCatalog:nil];
}

+ (void)importDataFromFile:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self parseData:data withCatalog:nil];
}

+ (void)parseData:(NSData *)data withCatalog:(Catalog *)catalog
{
    NSError *error = nil;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data error:&error];
    
    [self deleteAllObjectsWithCatalog:catalog];
    
    if (xmlDictionary && error == nil)
    {
        NSDictionary *assessmentTest = [xmlDictionary objectForKey:@"assessmentTest"];
        
        if (assessmentTest)
        {
            NSObject *testPart = [assessmentTest objectForKey:@"testPart"];
            
            if ([testPart isKindOfClass:[NSArray class]])
            {
                NSArray *testArray = (NSArray *)testPart;
                
                for (NSDictionary *test in testArray)
                {
                    [P2LQTITestPartImporter importTestUsingDictionary:test andCatalog:catalog];
                }
            }
            else if ([testPart isKindOfClass:[NSDictionary class]])
            {
                [P2LQTITestPartImporter importTestUsingDictionary:(NSDictionary *)testPart andCatalog:catalog];
            }
            else
            {
                NSLog(@"Error: testPart Node not found!");
            }
        }
        else
        {
            NSLog(@"Error: assessmentTest Node not found!");
        }
    }
    else
    {
        NSLog(@"Error importing data: %@", error);
    }
    
}

+ (void)deleteAllObjectsWithCatalog:(Catalog *)catalog
{
    // grab lessons
    NSArray *lessons = [catalog.lessons allObjects];
    
    // grab all questions
    NSMutableArray *questions = [NSMutableArray new];
    NSMutableArray *answers = [NSMutableArray new];
    
    for (Lesson *lesson in questions)
    {
        [questions addObjectsFromArray:[lesson.questions allObjects]];
        
        // grab all answers
        for (Question *question in lesson.questions)
        {
            [answers addObjectsFromArray:[question.answers allObjects]];
        }
    }
    
    for (Answer *answer in answers)
    {
        [[P2LModelManager currentContext] deleteObject:answer];
    }
    
    for (Question *question in questions)
    {
        [[P2LModelManager currentContext] deleteObject:question];
    }
    
    for (Lesson *lesson in lessons)
    {
        [[P2LModelManager currentContext] deleteObject:lesson];
    }
}

+ (void)deleteAllObjects:(NSString *)entityName withCatalog:(Catalog *)catalog
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:[P2LModelManager currentContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[P2LModelManager currentContext] executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items)
    {
    	[[P2LModelManager currentContext] deleteObject:managedObject];
    	NSLog(@"%@ object deleted", entityName);
    }
    if (![[P2LModelManager currentContext] save:&error])
    {
    	NSLog(@"Error deleting %@ - error:%@", entityName, error);
    }
    
}

@end

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
    
    [self deleteAllObjects:@"Lesson"];
    [self deleteAllObjects:@"Question"];
    [self deleteAllObjects:@"Answer"];
    [self deleteAllObjects:@"Inquiry"];
    [self deleteAllObjects:@"PrimaryKey"];
    
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

+ (void)deleteAllObjects:(NSString *)entityName
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

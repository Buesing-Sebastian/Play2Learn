//
//  P2LQTIImporter.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catalog.h"

@interface P2LQTIImporter : NSObject

+ (void)importDataForCatalog:(Catalog *)catalog;

+ (void)importDataFromURL:(NSURL *)url;

+ (void)importDataFromFile:(NSString *)filePath;

+ (void)deleteAllObjects:(NSString *)entityName;

@end

//
//  P2LQTITestPartImporter.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catalog.h"

@interface P2LQTITestPartImporter : NSObject

+ (void)importTestUsingDictionary:(NSDictionary *)testPartDictionary  andCatalog:(Catalog *)catalog;

@end

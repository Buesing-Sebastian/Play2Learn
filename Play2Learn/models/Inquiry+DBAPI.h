//
//  Inquiry+DBAPI.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 31.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Inquiry.h"
#import "P2LDBAPIProtocol.h"
#import "Catalog.h"

@interface Inquiry (DBAPI) <P2LDBAPIProtocol>

+ (NSArray *)allInquiriesForCatalog:(Catalog *)catalog;

- (NSString *)timeSpanStringUsingFormat:(NSString *)formatString;

@end

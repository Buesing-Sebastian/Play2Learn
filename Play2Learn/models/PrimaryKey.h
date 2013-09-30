//
//  PrimaryKey.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 29.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrimaryKey : NSManagedObject

@property (nonatomic) int64_t answer;
@property (nonatomic) int32_t catalog;
@property (nonatomic) int32_t lesson;
@property (nonatomic) int32_t question;

@end

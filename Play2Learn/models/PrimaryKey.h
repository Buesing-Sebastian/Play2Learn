//
//  PrimaryKey.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrimaryKey : NSManagedObject

@property (nonatomic) int64_t answer;
@property (nonatomic) int32_t inquiry;
@property (nonatomic) int32_t lesson;
@property (nonatomic) int32_t question;
@property (nonatomic) int32_t catalog;

@end

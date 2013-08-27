//
//  Answer.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 02.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * primaryKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Question *question;

@end

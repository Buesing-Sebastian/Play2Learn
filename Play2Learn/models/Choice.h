//
//  Choice.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Inquiry, Question;

@interface Choice : NSManagedObject

@property (nonatomic) BOOL correct;
@property (nonatomic) BOOL value;
@property (nonatomic, retain) Answer *answer;
@property (nonatomic, retain) Inquiry *inquiry;
@property (nonatomic, retain) Question *question;

@end

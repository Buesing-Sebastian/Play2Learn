//
//  Choice+DBChoice.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Choice+DBChoice.h"
#import "P2LModelManager.h"

@implementation Choice (DBChoice)

- (id)initWithInquiry:(Inquiry *)inquiry question:(Question *)question andAnswers:(Answer *)answer
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Choice" inManagedObjectContext:context];
    
    self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    if (self)
    {
        self.inquiry = inquiry;
        self.question = question;
        self.answer = answer;
    }
    
    return self;
}

- (void)save
{
    NSManagedObjectContext *context = [P2LModelManager currentContext];
    
    NSError *error;
    [context save:&error];
}

@end

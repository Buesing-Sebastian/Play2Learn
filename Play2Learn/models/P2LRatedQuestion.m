//
//  P2LRatedQuestion.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LRatedQuestion.h"

@implementation P2LRatedQuestion

- (id)init
{
    self = [super init];
    if (self)
    {
        self.rating = 1.0f;
        self.numChosen = 0;
        self.lastCorrectness = 0.0f;
        self.avgCorrectness = 0.0f;
    }
    return self;
}

- (id)initWithQuestion:(Question *)question
{
    self = [super init];
    if (self)
    {
        self.question = question;
        self.rating = 1.0f;
        self.numChosen = 0;
        self.lastCorrectness = 0.0f;
        self.avgCorrectness = 0.0f;
    }
    return self;
}

@end

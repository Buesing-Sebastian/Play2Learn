//
//  P2LRatedQuestion.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.09.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface P2LRatedQuestion : NSObject

@property (nonatomic, strong) Question *question;
@property (nonatomic, assign) float rating;
@property (nonatomic, assign) int numChosen;
@property (nonatomic, assign) float lastCorrectness;
@property (nonatomic, assign) float avgCorrectness;

- (id)initWithQuestion:(Question *)question;

@end

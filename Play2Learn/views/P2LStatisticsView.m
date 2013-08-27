//
//  P2LStatisticsView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LStatisticsView.h"

@interface P2LStatisticsView ()

@property (nonatomic, strong) UILabel *questions;
@property (nonatomic, strong) UILabel *percent;

@end

@implementation P2LStatisticsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.questions = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 44)];
        self.percent = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, frame.size.width-20, 44)];
        
        [self addSubview:self.questions];
        [self addSubview:self.percent];
    }
    return self;
}

- (void)setQuestionCount:(int)questionCount
{
    self.questions.text = [NSString stringWithFormat:@"Anzahl an Fragen:  %d", questionCount];
    
    _questionCount = questionCount;
}

- (void)setPercentCorrect:(float)percentCorrect
{
    self.percent.text = [NSString stringWithFormat:@"Prozent richtiger Antworten:  %.2f", percentCorrect];
    
    _percentCorrect = percentCorrect;
}

@end

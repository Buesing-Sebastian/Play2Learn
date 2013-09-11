//
//  P2LStatisticsQuestionView.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question+DBAPI.h"
#import "P2LStatisticsInquiryViewController.h"

@interface P2LStatisticsQuestionView : UIView

@property (nonatomic, strong) P2LStatisticsInquiryViewController *delegate;

@property (nonatomic, assign) int row;
@property (nonatomic, strong) UILabel *questionNumberLabel;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) UILabel *percentScoreLabel;

@property (nonatomic, strong) UILabel *answerChoiceA;
@property (nonatomic, strong) UILabel *answerCorrectA;

@property (nonatomic, strong) UILabel *answerChoiceB;
@property (nonatomic, strong) UILabel *answerCorrectB;

@property (nonatomic, strong) UILabel *answerChoiceC;
@property (nonatomic, strong) UILabel *answerCorrectC;

@property (nonatomic, strong) UILabel *answerChoiceD;
@property (nonatomic, strong) UILabel *answerCorrectD;

@end

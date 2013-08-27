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
@property (nonatomic, strong) NSArray *choices;

@end

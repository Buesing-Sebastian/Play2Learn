//
//  P2LStatisticsTableViewCell.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 10.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P2LStatisticsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *lessonLabel;
@property (nonatomic, strong) UILabel *timeSpanLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *questionsLabel;
@property (nonatomic, strong) UILabel *percentScoreLabel;

@end

//
//  P2LStatisticsTableViewCell.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 10.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LStatisticsTableViewCell.h"

@implementation P2LStatisticsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        _lessonLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 400, 28)];
        _timeSpanLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 400, 19)];
        _timeSpanLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(560, 12, 95, 23)];
        _questionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(560, 32, 95, 22)];
        _percentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(643, 10, 85, 44)];
        
        // set fonts
        _lessonLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20.0f];
        _timeSpanLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:12.0f];
        _scoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20.0f];
        _questionsLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:14.0f];
        _percentScoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:36.0f];
        
        // add as as subviews
        [self addSubview:_cellIcon];
        [self addSubview:_lessonLabel];
        [self addSubview:_timeSpanLabel];
        [self addSubview:_scoreLabel];
        [self addSubview:_questionsLabel];
        [self addSubview:_percentScoreLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

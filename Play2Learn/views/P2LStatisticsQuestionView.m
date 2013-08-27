//
//  P2LStatisticsQuestionView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LStatisticsQuestionView.h"
#import "P2LMathMLView.h"
#import "Answer+DBAPI.h"
#import "Question+DBAPI.h"

@interface P2LStatisticsQuestionView ()

@property (nonatomic, strong) UILabel *answerLabelA;
@property (nonatomic, strong) UILabel *answerLabelB;
@property (nonatomic, strong) UILabel *answerLabelC;
@property (nonatomic, strong) UILabel *answerLabelD;

@property (nonatomic, strong) UIButton *answerButtonA;
@property (nonatomic, strong) UIButton *answerButtonB;
@property (nonatomic, strong) UIButton *answerButtonC;
@property (nonatomic, strong) UIButton *answerButtonD;

@property (nonatomic, strong) UIImageView *answerSelectionIconA;
@property (nonatomic, strong) UIImageView *answerSelectionIconB;
@property (nonatomic, strong) UIImageView *answerSelectionIconC;
@property (nonatomic, strong) UIImageView *answerSelectionIconD;

@property (nonatomic, strong) UIImageView *scrollViewBorderTop;
@property (nonatomic, strong) UIImageView *scrollViewBorderBottom;

@property (nonatomic, strong) UIButton *toggleButton;

@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UIImageView *questionSelectionIcon;

@property (nonatomic, assign) BOOL unfolded;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation P2LStatisticsQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _unfolded = NO;
        
        _questionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 44, 44)];
        _questionNumberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:36.0f];
        _questionNumberLabel.backgroundColor = [UIColor clearColor];
        _questionNumberLabel.userInteractionEnabled = NO;
        _questionNumberLabel.textAlignment = NSTextAlignmentCenter;

        _questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionButton.frame = CGRectMake(70, 70, 64, 64);
        [_questionButton setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
        [_questionButton setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
        
        _questionSelectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(94, 154, 16, 16)];
        _questionSelectionIcon.image = [UIImage imageNamed:@"circle_small.png"];
        
        // answers
        
        _answerButtonA = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButtonA.frame = CGRectMake(200, 90, 48, 48);
        [_answerButtonA setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
        [_answerButtonA setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
        
        _answerLabelA = [[UILabel alloc] initWithFrame:CGRectMake(206, 96, 36, 34)];
        _answerLabelA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:28.0f];
        _answerLabelA.backgroundColor = [UIColor clearColor];
        _answerLabelA.userInteractionEnabled = NO;
        _answerLabelA.textAlignment = NSTextAlignmentCenter;
        _answerLabelA.text = @"A";
        
        _answerSelectionIconA = [[UIImageView alloc] initWithFrame:CGRectMake(216, 154, 16, 16)];
        _answerSelectionIconA.image = [UIImage imageNamed:@"circle_small.png"];
        
        _answerButtonB = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButtonB.frame = CGRectMake(300, 90, 48, 48);
        [_answerButtonB setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
        [_answerButtonB setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
        
        _answerLabelB = [[UILabel alloc] initWithFrame:CGRectMake(306, 96, 36, 34)];
        _answerLabelB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:28.0f];
        _answerLabelB.backgroundColor = [UIColor clearColor];
        _answerLabelB.userInteractionEnabled = NO;
        _answerLabelB.textAlignment = NSTextAlignmentCenter;
        _answerLabelB.text = @"B";
        
        _answerSelectionIconB = [[UIImageView alloc] initWithFrame:CGRectMake(316, 154, 16, 16)];
        _answerSelectionIconB.image = [UIImage imageNamed:@"circle_small.png"];
        
        _answerButtonC = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButtonC.frame = CGRectMake(400, 90, 48, 48);
        [_answerButtonC setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
        [_answerButtonC setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
        
        _answerLabelC = [[UILabel alloc] initWithFrame:CGRectMake(406, 96, 36, 34)];
        _answerLabelC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:28.0f];
        _answerLabelC.backgroundColor = [UIColor clearColor];
        _answerLabelC.userInteractionEnabled = NO;
        _answerLabelC.textAlignment = NSTextAlignmentCenter;
        _answerLabelC.text = @"C";
        
        _answerSelectionIconC = [[UIImageView alloc] initWithFrame:CGRectMake(416, 154, 16, 16)];
        _answerSelectionIconC.image = [UIImage imageNamed:@"circle_small.png"];
        
        _answerButtonD = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButtonD.frame = CGRectMake(500, 90, 48, 48);
        [_answerButtonD setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
        [_answerButtonD setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
        
        _answerLabelD = [[UILabel alloc] initWithFrame:CGRectMake(506, 96, 36, 34)];
        _answerLabelD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:28.0f];
        _answerLabelD.backgroundColor = [UIColor clearColor];
        _answerLabelD.userInteractionEnabled = NO;
        _answerLabelD.textAlignment = NSTextAlignmentCenter;
        _answerLabelD.text = @"D";
        
        _answerSelectionIconD = [[UIImageView alloc] initWithFrame:CGRectMake(516, 154, 16, 16)];
        _answerSelectionIconD.image = [UIImage imageNamed:@"circle_small.png"];
        
        
        _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleButton.frame = CGRectMake(710, 158, 32, 32);
        [_toggleButton addTarget:self action:@selector(toggleQuestionView) forControlEvents:UIControlEventTouchUpInside];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down.png"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down_selected.png"] forState:UIControlStateHighlighted];
        
        // scrollView
        
        _scrollViewBorderTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, 768, 32)];
        _scrollViewBorderTop.image = [UIImage imageNamed:@"delimter_top.png"];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.frame.size.width, 0)];
        
        
        _scrollViewBorderBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 198, 768, 32)];
        _scrollViewBorderBottom.image = [UIImage imageNamed:@"delimter_bottom.png"];
        
        // add subviews
        [self addSubview:_questionButton];
        [self addSubview:_questionNumberLabel];
        [self addSubview:_questionSelectionIcon];
        
        [self addSubview:_answerButtonA];
        [self addSubview:_answerLabelA];
        [self addSubview:_answerSelectionIconA];
        
        [self addSubview:_answerButtonB];
        [self addSubview:_answerLabelB];
        [self addSubview:_answerSelectionIconB];
        
        [self addSubview:_answerButtonC];
        [self addSubview:_answerLabelC];
        [self addSubview:_answerSelectionIconC];
        
        [self addSubview:_answerButtonD];
        [self addSubview:_answerLabelD];
        [self addSubview:_answerSelectionIconD];
        
        [self addSubview:_toggleButton];
        [self addSubview:_scrollViewBorderTop];
        [self addSubview:_scrollViewBorderBottom];
        
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setRow:(int)row
{
    _questionNumberLabel.text = [NSString stringWithFormat:@"%d", (row + 1)];
    
    _row = row;
}

- (void)toggleQuestionView
{
    if (!_unfolded)
    {
        [self.delegate setHeight:430 forRow:self.row];
        [_toggleButton setImage:[UIImage imageNamed:@"back_top.png"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"back_top_selected.png"] forState:UIControlStateHighlighted];
        
        if (self.scrollView.contentSize.width <= self.frame.size.width)
        {
            P2LMathMLView *questionView = [[P2LMathMLView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
            questionView.latexCode = self.question.prompt;
            
            [self.scrollView addSubview:questionView];
            
            NSArray *answers = [self.question.answers allObjects];
            
            for (int i = 0; i < self.question.answers.count; i++)
            {
                Answer *answer = [answers objectAtIndex:i];
                
                P2LMathMLView *answerView = [[P2LMathMLView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width, 0, self.frame.size.width, 200)];
                answerView.latexCode = answer.text;
                
                [self.scrollView addSubview:answerView];
                
                _scrollView.contentSize = CGSizeMake((self.question.answers.count + 1) * self.frame.size.width, 200);
            }
            _scrollView.frame = CGRectMake(0, 200, self.frame.size.width, 200);
            
        }
        
        _scrollViewBorderBottom.frame = CGRectMake(0, 398, 768, 32);
    }
    else
    {
        [self.delegate setHeight:230 forRow:self.row];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down.png"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down_selected.png"] forState:UIControlStateHighlighted];
        
        _scrollViewBorderBottom.frame = CGRectMake(0, 205, 768, 32);
        _scrollView.frame = CGRectMake(0, 200, self.frame.size.width, 0);
    }
    
    [self setNeedsDisplay];
    
    _unfolded = !_unfolded;
}

@end

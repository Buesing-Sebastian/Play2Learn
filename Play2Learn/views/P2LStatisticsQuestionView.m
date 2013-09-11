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

#define scrollViewHeight 230.0f

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

@property (nonatomic, strong) UIImageView *selectedIcon;


@property (nonatomic, assign) BOOL unfolded;
@property (nonatomic, assign) CGRect initialScrollViewFrame;
@property (nonatomic, assign) CGRect expandedScrollViewFrame;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation P2LStatisticsQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _unfolded = NO;
        
        // iPhone
        if (frame.size.width == 320)
        {
            [self setupViewsForiPhone];
        }
        else
        {
            // iPad
            [self setupViewsForiPad];
        }
        
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
        
        [self addSubview:_percentScoreLabel];
        [self addSubview:_toggleButton];
        [self addSubview:_scrollViewBorderTop];
        [self addSubview:_scrollViewBorderBottom];
        
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setupViewsForiPhone
{
    _questionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 44, 44)];
    _questionNumberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:30.0f];
    _questionNumberLabel.backgroundColor = [UIColor clearColor];
    _questionNumberLabel.userInteractionEnabled = NO;
    _questionNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    _questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _questionButton.frame = CGRectMake(10, 10, 48, 48);
    [_questionButton setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_questionButton setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_questionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _questionSelectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(26, 64, 16, 16)];
    _questionSelectionIcon.image = [UIImage imageNamed:@"circle_small.png"];
    
    // answers
    
    _answerButtonA = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerButtonA.frame = CGRectMake(70, 20, 40, 40);
    [_answerButtonA setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_answerButtonA setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_answerButtonA addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerLabelA = [[UILabel alloc] initWithFrame:CGRectMake(72, 22, 36, 36)];
    _answerLabelA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:24.0f];
    _answerLabelA.backgroundColor = [UIColor clearColor];
    _answerLabelA.userInteractionEnabled = NO;
    _answerLabelA.textAlignment = NSTextAlignmentCenter;
    _answerLabelA.text = @"A";
    
    _answerSelectionIconA = [[UIImageView alloc] initWithFrame:CGRectMake(82, 68, 16, 16)];
    _answerSelectionIconA.image = [UIImage imageNamed:@"circle_small.png"];
    
    _answerButtonB = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerButtonB.frame = CGRectMake(120, 20, 40, 40);
    [_answerButtonB setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_answerButtonB setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_answerButtonB addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerLabelB = [[UILabel alloc] initWithFrame:CGRectMake(122, 22, 36, 36)];
    _answerLabelB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:24.0f];
    _answerLabelB.backgroundColor = [UIColor clearColor];
    _answerLabelB.userInteractionEnabled = NO;
    _answerLabelB.textAlignment = NSTextAlignmentCenter;
    _answerLabelB.text = @"B";
    
    _answerSelectionIconB = [[UIImageView alloc] initWithFrame:CGRectMake(132, 68, 16, 16)];
    _answerSelectionIconB.image = [UIImage imageNamed:@"circle_small.png"];
    
    _answerButtonC = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerButtonC.frame = CGRectMake(170, 20, 40, 40);
    [_answerButtonC setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_answerButtonC setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_answerButtonC addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerLabelC = [[UILabel alloc] initWithFrame:CGRectMake(172, 22, 36, 36)];
    _answerLabelC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:24.0f];
    _answerLabelC.backgroundColor = [UIColor clearColor];
    _answerLabelC.userInteractionEnabled = NO;
    _answerLabelC.textAlignment = NSTextAlignmentCenter;
    _answerLabelC.text = @"C";
    
    _answerSelectionIconC = [[UIImageView alloc] initWithFrame:CGRectMake(182, 68, 16, 16)];
    _answerSelectionIconC.image = [UIImage imageNamed:@"circle_small.png"];
    
    _answerButtonD = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerButtonD.frame = CGRectMake(220, 20, 40, 40);
    [_answerButtonD setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_answerButtonD setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_answerButtonD addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerLabelD = [[UILabel alloc] initWithFrame:CGRectMake(222, 22, 36, 36)];
    _answerLabelD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:24.0f];
    _answerLabelD.backgroundColor = [UIColor clearColor];
    _answerLabelD.userInteractionEnabled = NO;
    _answerLabelD.textAlignment = NSTextAlignmentCenter;
    _answerLabelD.text = @"D";
    
    _answerSelectionIconD = [[UIImageView alloc] initWithFrame:CGRectMake(232, 68, 16, 16)];
    _answerSelectionIconD.image = [UIImage imageNamed:@"circle_small.png"];
    
    
    _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleButton.frame = CGRectMake(270, 44, 32, 32);
    [_toggleButton addTarget:self action:@selector(toggleQuestionView) forControlEvents:UIControlEventTouchUpInside];
    [_toggleButton setImage:[UIImage imageNamed:@"back_down.png"] forState:UIControlStateNormal];
    [_toggleButton setImage:[UIImage imageNamed:@"back_down_selected.png"] forState:UIControlStateHighlighted];
    
    // scrollView
    
    _scrollViewBorderTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, 32)];
    _scrollViewBorderTop.image = [UIImage imageNamed:@"delimter_top.png"];
    
    _initialScrollViewFrame = CGRectMake(0, 100, self.frame.size.width, 0);
    _expandedScrollViewFrame = CGRectMake(0, 100, self.frame.size.width, scrollViewHeight);
    _scrollView = [[UIScrollView alloc] initWithFrame:_initialScrollViewFrame];
    
    CGFloat xOffset = self.frame.size.width;
    
    _answerChoiceA = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 40, 205, 120, 20)];
    _answerChoiceA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    _answerCorrectA = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 160, 205, 120, 20)];
    _answerCorrectA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    
    [self.scrollView addSubview:_answerChoiceA];
    [self.scrollView addSubview:_answerCorrectA];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceB = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 40, 205, 120, 20)];
    _answerChoiceB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    _answerCorrectB = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 160, 205, 120, 20)];
    _answerCorrectB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    
    [self.scrollView addSubview:_answerChoiceB];
    [self.scrollView addSubview:_answerCorrectB];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceC = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 40, 205, 120, 20)];
    _answerChoiceC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    _answerCorrectC = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 160, 205, 120, 20)];
    _answerCorrectC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    
    [self.scrollView addSubview:_answerChoiceC];
    [self.scrollView addSubview:_answerCorrectC];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceD = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 40, 205, 120, 20)];
    _answerChoiceD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    _answerCorrectD = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 160, 205, 120, 20)];
    _answerCorrectD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:12.0f];
    
    [self.scrollView addSubview:_answerChoiceD];
    [self.scrollView addSubview:_answerCorrectD];
    
    _scrollViewBorderBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 98, self.frame.size.width, 32)];
    _scrollViewBorderBottom.image = [UIImage imageNamed:@"delimter_bottom.png"];
    
    _percentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 10, 50, 30)];
    _percentScoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:22.0f];
    _percentScoreLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setupViewsForiPad
{
    _questionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 44, 44)];
    _questionNumberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:36.0f];
    _questionNumberLabel.backgroundColor = [UIColor clearColor];
    _questionNumberLabel.userInteractionEnabled = NO;
    _questionNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    _questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _questionButton.frame = CGRectMake(70, 70, 64, 64);
    [_questionButton setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_questionButton setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_questionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _questionSelectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(94, 154, 16, 16)];
    _questionSelectionIcon.image = [UIImage imageNamed:@"circle_small.png"];
    
    // answers
    
    _answerButtonA = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerButtonA.frame = CGRectMake(200, 90, 48, 48);
    [_answerButtonA setImage:[UIImage imageNamed:@"circle_big.png"] forState:UIControlStateNormal];
    [_answerButtonA setImage:[UIImage imageNamed:@"circle_big_selected.png"] forState:UIControlStateHighlighted];
    [_answerButtonA addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_answerButtonB addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_answerButtonC addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_answerButtonD addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    _initialScrollViewFrame = CGRectMake(0, 200, self.frame.size.width, 0);
    _expandedScrollViewFrame = CGRectMake(0, 200, self.frame.size.width, scrollViewHeight);
    _scrollView = [[UIScrollView alloc] initWithFrame:_initialScrollViewFrame];
    
    CGFloat xOffset = self.frame.size.width;
    
    _answerChoiceA = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 100, 205, 200, 20)];
    _answerChoiceA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    _answerCorrectA = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 300, 205, 200, 20)];
    _answerCorrectA.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    
    [self.scrollView addSubview:_answerChoiceA];
    [self.scrollView addSubview:_answerCorrectA];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceB = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 100, 205, 200, 20)];
    _answerChoiceB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    _answerCorrectB = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 300, 205, 200, 20)];
    _answerCorrectB.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    
    [self.scrollView addSubview:_answerChoiceB];
    [self.scrollView addSubview:_answerCorrectB];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceC = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 100, 205, 200, 20)];
    _answerChoiceC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    _answerCorrectC = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 300, 205, 200, 20)];
    _answerCorrectC.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    
    [self.scrollView addSubview:_answerChoiceC];
    [self.scrollView addSubview:_answerCorrectC];
    
    xOffset += self.frame.size.width;
    
    _answerChoiceD = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 100, 205, 200, 20)];
    _answerChoiceD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    _answerCorrectD = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + self.frame.size.width - 300, 205, 200, 20)];
    _answerCorrectD.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:14.0f];
    
    [self.scrollView addSubview:_answerChoiceD];
    [self.scrollView addSubview:_answerCorrectD];
    
    _scrollViewBorderBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 198, 768, 32)];
    _scrollViewBorderBottom.image = [UIImage imageNamed:@"delimter_bottom.png"];
    
    _percentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(600, 70, 104, 64)];
    _percentScoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:36.0f];
    _percentScoreLabel.textAlignment = NSTextAlignmentRight;
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
        [self.delegate setHeight:(_initialScrollViewFrame.origin.y + 30 +scrollViewHeight) forRow:self.row];
        [_toggleButton setImage:[UIImage imageNamed:@"back_top.png"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"back_top_selected.png"] forState:UIControlStateHighlighted];
        
        if (self.scrollView.contentSize.width <= self.frame.size.width)
        {
            P2LMathMLView *questionView = [[P2LMathMLView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
            questionView.latexCode = self.question.prompt;
            
            [self.scrollView addSubview:questionView];
            
            for (int i = 0; i < self.answers.count; i++)
            {
                Answer *answer = [self.answers objectAtIndex:i];
                
                P2LMathMLView *answerView = [[P2LMathMLView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width, 0, self.frame.size.width, 200)];
                answerView.latexCode = answer.text;
                
                [self.scrollView addSubview:answerView];
                
                _scrollView.contentSize = CGSizeMake((self.question.answers.count + 1) * self.frame.size.width, scrollViewHeight);
            }
            
            _selectedIcon = _questionSelectionIcon;
            [_questionSelectionIcon setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
        }
        _scrollView.frame = _expandedScrollViewFrame;
        CGFloat yOffset = (_initialScrollViewFrame.origin.y + scrollViewHeight + 28);
        _scrollViewBorderBottom.frame = CGRectMake(0, yOffset, _initialScrollViewFrame.size.width, 32);
    }
    else
    {
        [self.delegate setHeight:(_initialScrollViewFrame.origin.y + 30) forRow:self.row];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down.png"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"back_down_selected.png"] forState:UIControlStateHighlighted];
        
        _scrollViewBorderBottom.frame = CGRectMake(0, _initialScrollViewFrame.origin.y + 5, _initialScrollViewFrame.size.width, 32);
        _scrollView.frame = _initialScrollViewFrame;
    }
    
    [self setNeedsDisplay];
    
    _unfolded = !_unfolded;
}

- (void)buttonClicked:(UIButton *)sender
{
    if (_unfolded)
    {
        if (sender == _questionButton)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            
                _scrollView.contentOffset = CGPointMake(0, 0);
                
                [_selectedIcon setImage:[UIImage imageNamed:@"circle_small.png"]];
                [_questionSelectionIcon setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
                _selectedIcon = _questionSelectionIcon;
                
            } completion:nil];
        }
        else if (sender == _answerButtonA)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                
                _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
                
                [_selectedIcon setImage:[UIImage imageNamed:@"circle_small.png"]];
                [_answerSelectionIconA setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
                _selectedIcon = _answerSelectionIconA;
                
            } completion:nil];
        }
        else if (sender == _answerButtonB)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                
                _scrollView.contentOffset = CGPointMake(self.frame.size.width * 2, 0);
                
                [_selectedIcon setImage:[UIImage imageNamed:@"circle_small.png"]];
                [_answerSelectionIconB setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
                _selectedIcon = _answerSelectionIconB;
                
            } completion:nil];
        }
        else if (sender == _answerButtonC)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                
                _scrollView.contentOffset = CGPointMake(self.frame.size.width * 3, 0);
                
                [_selectedIcon setImage:[UIImage imageNamed:@"circle_small.png"]];
                [_answerSelectionIconC setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
                _selectedIcon = _answerSelectionIconC;
                
            } completion:nil];
        }
        else if (sender == _answerButtonD)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                
                _scrollView.contentOffset = CGPointMake(self.frame.size.width * 4, 0);
                
                [_selectedIcon setImage:[UIImage imageNamed:@"circle_small.png"]];
                [_answerSelectionIconD setImage:[UIImage imageNamed:@"circle_small_selected.png"]];
                _selectedIcon = _answerSelectionIconD;
                
            } completion:nil];
        }
    }
    else
    {
        [self toggleQuestionView];
        [self buttonClicked:sender];
    }
}

@end

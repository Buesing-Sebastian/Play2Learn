//
//  P2LQuestionView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LQuestionView.h"
#import "P2LMathMLView.h"
#import "Answer+DBAPI.h"

@interface P2LQuestionView ()

@property (nonatomic, strong) NSMutableArray *answerViews;
@property (nonatomic, strong) NSMutableArray *answersSegmentControls;
@property (nonatomic, strong) NSMutableArray *noteLabels;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) P2LMathMLView *promptView;

@end

@implementation P2LQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        
        _answerViews = [NSMutableArray new];
        _noteLabels = [NSMutableArray new];
        _answersSegmentControls = [NSMutableArray new];
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_submitButton setTitle:@"submit" forState:UIControlStateNormal];
        _submitButton.frame = CGRectMake(0, 0, 80, 44);
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_nextButton setTitle:@"next" forState:UIControlStateNormal];
        _nextButton.frame = CGRectMake(0, 0, 80, 44);
        _nextButton.enabled = NO;
        
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return self;
}

#pragma mark - overrides

- (void)setAnswers:(NSArray *)answers
{
    _answers = answers;
    
    [self setUpView];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setPrompt:(NSString *)prompt
{
    _prompt = prompt;
    
    [self.promptView setLatexCode:prompt];
}

#pragma mark - public

- (void)enableNextButton
{
    self.nextButton.enabled = YES;
}

- (void)disableSubmitButton
{
    self.submitButton.enabled = NO;
}

- (void)enableInteraction
{
    self.userInteractionEnabled = YES;
}

- (void)disableInteraction
{
    self.userInteractionEnabled = NO;
    self.submitButton.enabled = NO;
    self.nextButton.enabled = NO;
}

- (void)setNote:(NSString *)note forAnswerAtIndex:(int)index
{
    UILabel *label = [self.noteLabels objectAtIndex:index];
    label.text = note;
}

- (BOOL)checkedAnswerAtIndex:(int)index
{
    UISegmentedControl *control = [self.answersSegmentControls objectAtIndex:index];
    
    return (control.selectedSegmentIndex == 0);
}

#pragma mark - private

- (void)setUpView
{
    CGSize size = self.frame.size;
    CGSize contentSize = size;
    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width-10, 44)];
//    self.titleLabel.text = self.title;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [self addSubview:self.titleLabel];
//    
//    contentSize.height += 60;
    
    self.promptView = [[P2LMathMLView alloc] initWithFrame:CGRectMake(5, 10, size.width-10, 150)];
    self.promptView.latexCode = self.prompt;
    
    [self addSubview:self.promptView];
    
    contentSize.height += 170;
    
    NSArray *items = [NSArray arrayWithObjects:@"richtig", @"falsch", nil];
    
    for (Answer *answer in self.answers)
    {
        CGFloat y = contentSize.height - size.height;
        
        P2LMathMLView *answerView = [[P2LMathMLView alloc] initWithFrame:CGRectMake(5, y, size.width-10, 100)];
        answerView.latexCode = answer.text;
        
        [self addSubview:answerView];
        
        y += 105;
        
        UILabel *answerNote = [[UILabel alloc] initWithFrame:CGRectMake(10, y, size.width * 0.4, 35)];
        answerNote.text = @"";
        answerNote.backgroundColor = [UIColor clearColor];
        
        [self addSubview:answerNote];
        
        [self.noteLabels addObject:answerNote];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        segmentedControl.frame = CGRectMake(size.width * 0.6, y, size.width * 0.4, 35);
        segmentedControl.selectedSegmentIndex = 1;
        
        [self addSubview:segmentedControl];
        [self.answersSegmentControls addObject:segmentedControl];
        
        contentSize.height += 170;
    }
    
    CGFloat y = contentSize.height - size.height;
    
    self.submitButton.frame = CGRectMake(10, y, 80, 44);
    self.nextButton.frame = CGRectMake(size.width - 90, y, 80, 44);
    
    [self addSubview:self.submitButton];
    [self addSubview:self.nextButton];
    
    [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(submitPressed) forControlEvents:UIControlEventTouchUpInside];
    
    contentSize.height += 60;
    contentSize.height -= size.height;
    
    self.contentSize = contentSize;
}

#pragma mark - UIButton target actions

- (void)nextPressed
{
    [self.controller nextQuestion];
}

- (void)submitPressed
{
    [self.controller submitQuestion];
}

- (void)removeFromSuperview
{
    self.controller = nil;
    [super removeFromSuperview];
}

@end

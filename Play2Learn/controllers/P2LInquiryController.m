//
//  P2LInquiryController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LInquiryController.h"
#import "P2LQuestionView.h"
#import "P2LStatisticsView.h"
#import "Question+DBAPI.h"
#import "Choice+DBChoice.h"
#import "P2LModelManager.h"

@interface P2LInquiryController ()


@property (nonatomic, strong) NSMutableDictionary *choices;

@property (nonatomic, strong) NSArray *questions;

@property (nonatomic, strong) P2LQuestionView *currentView;
@property (nonatomic, strong) P2LQuestionView *nextView;

@property (nonatomic, assign) int currentQuestionIndex;

@property (nonatomic, assign) int correctAnswers;
@property (nonatomic, assign) int wrongAnsers;

@end

@implementation P2LInquiryController

- (id)initWithInquiry:(Inquiry *)inquiry
{
    self = [super init];
    if (self)
    {
        _inquiry = inquiry;
        
        self.view = [[UIView alloc] initWithFrame:CGRectZero];
        self.view.backgroundColor = [UIColor cyanColor];
        self.questions = [inquiry.questions allObjects];
    }
    return self;
}

- (void)startInquiry
{
    [self setDefaults];
    
    P2LQuestionView *nextView = [self nextQuestionView];
    [self slideInNewQuestionView:nextView];
}

- (void)nextQuestion
{
    NSArray *choices = [self.choices objectForKey:[NSString stringWithFormat:@"%d", self.currentQuestionIndex]];
    
    if (choices)
    {
        P2LQuestionView *nextView = [self nextQuestionView];
        if (nextView)
        {
            [self slideInNewQuestionView:nextView];
        }
        else
        {
            [self slideInStatistics];
        }
    }
}

- (void)submitQuestion
{
    if ([self.choices objectForKey:[NSString stringWithFormat:@"%d", self.currentQuestionIndex]])
    {
        return;
    }
    
    Question *currentQuestion = [self.questions objectAtIndex:self.currentQuestionIndex];
    
    NSArray *currentAnswers = self.currentView.answers;
    
    NSMutableArray *currentChoices = [NSMutableArray new];
    
    for (int i = 0; i < [currentAnswers count]; i++)
    {
        BOOL checked = [self.currentView checkedAnswerAtIndex:i];
        
        Answer *answer = [currentAnswers objectAtIndex:i];
        
        if (checked && [[currentQuestion.correctAnswers allObjects] containsObject:answer])
        {
            [self.currentView setNote:@"Richtig!" forAnswerAtIndex:i];
            self.correctAnswers++;
        }
        else if (!checked && ![[currentQuestion.correctAnswers allObjects] containsObject:answer])
        {
            [self.currentView setNote:@"Richtig!" forAnswerAtIndex:i];
            self.correctAnswers++;
        }
        else
        {
            [self.currentView setNote:@"Falsch!" forAnswerAtIndex:i];
            self.wrongAnsers++;
        }
        // save choice
        Choice *choice = [[Choice alloc] initWithInquiry:self.inquiry question:currentQuestion andAnswers:answer];
        choice.value = checked;
        
        NSError *error;
        
        [[P2LModelManager currentContext] save:&error];
        
        [currentChoices addObject:choice];
    }
    [self.choices setObject:currentChoices forKey:[NSString stringWithFormat:@"%d", self.currentQuestionIndex]];
    
    [self.currentView enableNextButton];
}

#pragma mark - private methods

- (void)setDefaults
{
    _choices = [NSMutableDictionary new];
    _currentQuestionIndex = -1;
    
    _wrongAnsers = 0;
    _correctAnswers = 0;
}

- (P2LQuestionView *)nextQuestionView
{
    if (self.questions.count <= self.currentQuestionIndex+1)
    {
        return nil;
    }
    CGRect mainFrame = self.view.frame;
    
    P2LQuestionView *questionView = [[P2LQuestionView alloc] initWithFrame:mainFrame];
    
    Question *currentQuestion = [self.questions objectAtIndex:self.currentQuestionIndex+1];
    
    questionView.controller = self;
    questionView.title = currentQuestion.title.length ? currentQuestion.title : currentQuestion.lesson.name;
    questionView.prompt = currentQuestion.prompt;
    questionView.answers = [[currentQuestion answers] allObjects];
    
    return questionView;
}

- (void)slideInNewQuestionView:(P2LQuestionView *)questionView
{
    
    CGRect mainFrame = self.view.frame;
    
    mainFrame.origin.x = mainFrame.size.width;
    
    questionView.frame = mainFrame;
    
    [self.view addSubview:questionView];
    [self.currentView disableInteraction];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        questionView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        
    } completion:^(BOOL finished){
    
        [self.currentView removeFromSuperview];
        self.currentView = questionView;
        [self.currentView enableInteraction];
        self.currentQuestionIndex++;
    
    }];
}

- (void)slideInStatistics
{
    CGRect mainFrame = self.view.frame;
    
    mainFrame.origin.x = mainFrame.size.width;
    
    P2LStatisticsView *statisticsView = [[P2LStatisticsView alloc] initWithFrame:mainFrame];
    statisticsView.questionCount = [self.questions count];
    statisticsView.percentCorrect = (float)self.correctAnswers;
    statisticsView.percentCorrect /= (float)(self.correctAnswers + self.wrongAnsers);
    statisticsView.percentCorrect *= 100.0f;
    
    [self.view addSubview:statisticsView];
    
    [self.currentView disableInteraction];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        statisticsView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.currentView removeFromSuperview];
        self.currentView = nil;
        
    }];
}

@end

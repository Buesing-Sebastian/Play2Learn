//
//  P2LInquiryController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LInquiryViewController.h"
#import "P2LQuestionView.h"
#import "P2LStatisticsView.h"
#import "Question+DBAPI.h"
#import "Choice+DBChoice.h"
#import "Lesson+DBAPI.h"
#import "Inquiry+DBAPI.h"
#import "Answer+DBAPI.h"
#import "P2LModelManager.h"

@interface P2LInquiryViewController ()


@property (nonatomic, strong) NSMutableDictionary *choices;

@property (nonatomic, strong) NSArray *questions;

@property (nonatomic, strong) P2LQuestionView *currentView;
@property (nonatomic, strong) P2LQuestionView *nextView;

@property (nonatomic, strong) P2LStatisticsView *statisticsView;

@property (nonatomic, assign) int currentQuestionIndex;

@property (nonatomic, assign) int correctAnswers;
@property (nonatomic, assign) int wrongAnsers;

@end

@implementation P2LInquiryViewController

- (id)initWithInquiry:(Inquiry *)inquiry andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _inquiry = inquiry;
        
        self.questions = [inquiry.questions allObjects];
    }
    return self;
}

- (void)startInquiry
{
    [self setDefaults];
    
    self.inquiry.started = [[NSDate new] timeIntervalSince1970];
    [self.inquiry save];
    
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
    float correctness = self.correctAnswers;
    
    Question *currentQuestion = [self.questions objectAtIndex:self.currentQuestionIndex];
    
    NSArray *currentAnswers = self.currentView.answers;
    
    NSMutableArray *currentChoices = [NSMutableArray new];
    
    for (int i = 0; i < [currentAnswers count]; i++)
    {
        BOOL checked = [self.currentView checkedAnswerAtIndex:i];
        
        Answer *answer = [currentAnswers objectAtIndex:i];
        // save choice
        Choice *choice = [[Choice alloc] initWithInquiry:self.inquiry question:currentQuestion andAnswers:answer];
        choice.value = checked;
        
        if (checked && [[currentQuestion.correctAnswers allObjects] containsObject:answer])
        {
            [self.currentView setNote:@"Richtig!" forAnswerAtIndex:i];
            self.correctAnswers++;
            choice.correct = YES;
        }
        else if (!checked && ![[currentQuestion.correctAnswers allObjects] containsObject:answer])
        {
            [self.currentView setNote:@"Richtig!" forAnswerAtIndex:i];
            self.correctAnswers++;
            choice.correct = YES;
        }
        else
        {
            [self.currentView setNote:@"Falsch!" forAnswerAtIndex:i];
            self.wrongAnsers++;
            choice.correct = NO;
        }
        [choice save];
        
        NSError *error;
        
        [[P2LModelManager currentContext] save:&error];
        
        [answer addChoicesObject:choice];
        [self.inquiry addChoicesObject:choice];
        [self.inquiry save];
        [currentChoices addObject:choice];
    }
    [self.choices setObject:currentChoices forKey:[NSString stringWithFormat:@"%d", self.currentQuestionIndex]];
    
    // calculate correctness for question
    correctness = (self.correctAnswers - correctness) / (float)currentQuestion.answers.count;
    // inform delegate
    [self.delegate answeredQuestion:currentQuestion withCorrectness:correctness];
    
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
    // suffle the answers, so that the correct answers isn't always in
    // the same position.
    NSMutableArray *randomizedArray = [[[currentQuestion answers] allObjects] mutableCopy];
    
    NSUInteger count = randomizedArray.count;
    
    for (int i = 0; i < count; i++)
    {
        int j = (arc4random() % (count-1));
        
        if (i != j)
        {
            [randomizedArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    questionView.answers = randomizedArray;
    
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
        
        questionView.frame = CGRectMake(0, 60, mainFrame.size.width, mainFrame.size.height - 60);
        
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
    
    self.statisticsView = [[P2LStatisticsView alloc] initWithFrame:mainFrame];
    self.statisticsView.questionCount = [self.questions count];
    self.statisticsView.percentCorrect = (float)self.correctAnswers;
    self.statisticsView.percentCorrect /= (float)(self.correctAnswers + self.wrongAnsers);
    
    // save score
    self.inquiry.score = self.statisticsView.percentCorrect;
    self.inquiry.finished = [[NSDate new] timeIntervalSince1970];
    [self.inquiry save];
    
    self.statisticsView.percentCorrect *= 100.0f;
    
    [self.view addSubview:self.statisticsView];
    
    [self.currentView disableInteraction];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        self.statisticsView.frame = CGRectMake(0, 60, mainFrame.size.width, mainFrame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.currentView removeFromSuperview];
        self.currentView = nil;
        
        [self performSelector:@selector(sendFinish) withObject:self afterDelay:0.4];

    }];
}

- (void)sendFinish
{
    [self.delegate didFinishInquiry:self.inquiry withCorrectness:self.statisticsView.percentCorrect];
}

@end

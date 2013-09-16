//
//  P2LStatisticsInquiryViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LStatisticsInquiryViewController.h"
#import "P2LStatisticsQuestionView.h"
#import "P2LTableViewCell.h"
#import "Lesson+DBAPI.h"
#import "Choice+DBChoice.h"
#import "Answer+DBAPI.h"

@interface P2LStatisticsInquiryViewController ()

@property (nonatomic, strong) Inquiry *inquiry;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *heights;
@property (nonatomic, strong) NSMutableArray *viewBuffer;

@end

@implementation P2LStatisticsInquiryViewController

- (id)initWithFrame:(CGRect)frame andInquiry:(Inquiry *)inquiry
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //
        _inquiry = inquiry;
        
        CGRect frame = CGRectZero;
        // iPhone
        if (frame.size.width == 320)
        {
            [self setupViewsForiPhone];
            frame = CGRectMake(0, 0, self.view.frame.size.width, 130);
        }
        else
        {
            // iPad
            [self setupViewsForiPad];
            frame = CGRectMake(0, 0, self.view.frame.size.width, 230);
        }
        
        _heights = [NSMutableArray new];
        
        self.viewBuffer = [NSMutableArray new];
        
        NSArray *questions = [_inquiry.questions allObjects];
        
        
        
        for (int i = 0; i < _inquiry.questions.count; i++)
        {
            P2LStatisticsQuestionView *view = [[P2LStatisticsQuestionView alloc] initWithFrame:frame];
            view.row = i;
            view.delegate = self;
            view.question = [questions objectAtIndex:i];
            view.answers = [view.question.answers allObjects];
            view.percentScoreLabel.text = [self percentScoreStringForQuestion:view.question];
            [self setChoicesOnView:view];
            [_heights addObject:[NSNumber numberWithFloat:frame.size.height]];
            [_viewBuffer addObject:view];
        }
        
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)setupViewsForiPhone
{
    CGFloat width = self.view.frame.size.width;
    CGFloat offset = 60.0f;
    
    UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(width - 53, 5, 48, 48)];
    UILabel *lessonLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offset, width - 10, 24)];
    UILabel *timeSpanLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offset + 25, width - 10, 19)];
    timeSpanLabel.backgroundColor = [UIColor clearColor];
    UILabel *percentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 120, 40)];
    
    // set fonts
    lessonLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20.0f];
    timeSpanLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:12.0f];
    percentScoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:48.0f];
    
    cellIcon.image = [UIImage imageNamed:@"conquer.png"];
    lessonLabel.text = self.inquiry.lesson.name;
    timeSpanLabel.text = [self.inquiry timeSpanStringUsingFormat:@"dd/MM/yyyy HH:mm"];
    percentScoreLabel.text = [NSString stringWithFormat:@"%.00f%%", (self.inquiry.score * 100.0f)];
    
    // add as as subviews
    [self.view addSubview:cellIcon];
    [self.view addSubview:lessonLabel];
    [self.view addSubview:timeSpanLabel];
    [self.view addSubview:percentScoreLabel];
    
    offset = 120;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height-offset)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setupViewsForiPad
{
    CGFloat offset = 60.0f;
    
    UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, offset, 120, 120)];
    UILabel *lessonLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, offset, 400, 28)];
    UILabel *timeSpanLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, offset + 30, 400, 19)];
    timeSpanLabel.backgroundColor = [UIColor clearColor];
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(550, offset + 2, 85, 23)];
    UILabel *questionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(550, offset + 30, 85, 22)];
    UILabel *percentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(635, offset, 115, 50)];
    
    // set fonts
    lessonLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:24.0f];
    timeSpanLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:14.0f];
    scoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:22.0f];
    questionsLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:16.0f];
    percentScoreLabel.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:48.0f];
    
    cellIcon.image = [UIImage imageNamed:@"conquer.png"];
    lessonLabel.text = self.inquiry.lesson.name;
    timeSpanLabel.text = [self.inquiry timeSpanStringUsingFormat:@"dd/MM/yyyy HH:mm"];
    scoreLabel.text = @"score:";
    questionsLabel.text = [NSString stringWithFormat:@"%d questions", self.inquiry.questions.count];
    percentScoreLabel.text = [NSString stringWithFormat:@"%.00f%%", (self.inquiry.score * 100.0f)];
    
    // add as as subviews
    [self.view addSubview:cellIcon];
    [self.view addSubview:lessonLabel];
    [self.view addSubview:timeSpanLabel];
    [self.view addSubview:scoreLabel];
    [self.view addSubview:questionsLabel];
    [self.view addSubview:percentScoreLabel];
    
    offset = 204.0f;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height-offset)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSString *)percentScoreStringForQuestion:(Question *)question
{
    CGFloat score = 0.0;
    
    for (Choice *choice in _inquiry.choices)
    {
        if (choice.question == question)
        {
            if (choice.correct)
            {
                score += (1.0f / question.answers.count);
            }
        }
    }
    
    return [NSString stringWithFormat:@"%.00f%%", score * 100];
}

- (void)setChoicesOnView:(P2LStatisticsQuestionView *)view
{
    for (int i = 0; i < view.answers.count; i++)
    {
        Answer *answer = [view.answers objectAtIndex:i];
        
        // grab all choices
        NSMutableSet *searchedChoices = [NSMutableSet setWithSet:answer.choices];
        // intersect with choices of this inquiry
        // to the choices for the answer made in this
        // inquiry
        [searchedChoices intersectSet:_inquiry.choices];
        
        Choice *onlyChoice = [[searchedChoices allObjects] objectAtIndex:0];
        
        switch (i) {
            case 0:
            {
                if (onlyChoice.correct)
                {
                    view.answerChoiceA.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectA.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)onlyChoice.value];
                }
                else
                {
                    view.answerChoiceA.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectA.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)!onlyChoice.value];
                }
                
            }
                break;
            case 1:
            {
                if (onlyChoice.correct)
                {
                    view.answerChoiceB.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectB.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)onlyChoice.value];
                }
                else
                {
                    view.answerChoiceB.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectB.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)!onlyChoice.value];
                }
                
            }
                break;
            case 2:
            {
                if (onlyChoice.correct)
                {
                    view.answerChoiceC.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectC.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)onlyChoice.value];
                }
                else
                {
                    view.answerChoiceC.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectC.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)!onlyChoice.value];
                }
                
            }
                break;
            case 3:
            {
                if (onlyChoice.correct)
                {
                    view.answerChoiceD.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectD.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)onlyChoice.value];
                }
                else
                {
                    view.answerChoiceD.text = [NSString stringWithFormat:@"Deine Auswahl: %d", (int)onlyChoice.value];
                    view.answerCorrectD.text = [NSString stringWithFormat:@"Richtige Wahl: %d", (int)!onlyChoice.value];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeight:(CGFloat)height forRow:(int)row
{
    [_heights replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:height]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableView stuff


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"questionCell";
    
    P2LTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[P2LTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.subView = [_viewBuffer objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inquiry.questions count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_heights objectAtIndex:indexPath.row] floatValue];
}

@end

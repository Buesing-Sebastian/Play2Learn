//
//  P2LStatisticsViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LStatisticsViewController.h"
#import "P2LStatisticsTableViewCell.h"
#import "P2LStatisticsInquiryViewController.h"
#import "Lesson+DBAPI.h"
#import "Question+DBAPI.h"

@interface P2LStatisticsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *inquiries;

@end

@implementation P2LStatisticsViewController

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        CGRect tableViewFrame = CGRectMake(0, 55, self.view.frame.size.width - 0, self.view.frame.size.height - 40);
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        // add subviews
        [self.view addSubview:self.tableView];
        
        self.catalog = catalog;
        
        
        [self reloadData];
    }
    return self;
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

#pragma mark - private stuff

- (void)reloadData
{
    
    self.inquiries = [Inquiry allInquiriesForCatalog:self.catalog];
    
    
    
    [self.tableView reloadData];
}

#pragma mark - UITableView stuff

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StatisticsTableViewCell";
    
    P2LStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[P2LStatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Inquiry *inquiry = (Inquiry *)[self.inquiries objectAtIndex:indexPath.row];
    
    cell.cellIcon.image = [UIImage imageNamed:@"conquer.png"];
    cell.lessonLabel.text = inquiry.lesson.name;
    cell.timeSpanLabel.text = [self timeSpanStringWithStartDate:inquiry.started andEndDate:inquiry.finished];
    cell.scoreLabel.text = @"score:";
    cell.questionsLabel.text = [NSString stringWithFormat:@"%d questions", inquiry.questions.count];
    cell.percentScoreLabel.text = [self scoreStringForInquiry:inquiry];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inquiries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Inquiry *inuiry = (Inquiry *)[self.inquiries objectAtIndex:indexPath.row];
    
    
    P2LStatisticsInquiryViewController *viewController = [[P2LStatisticsInquiryViewController alloc] initWithFrame:self.view.frame
                                                                                                        andInquiry:inuiry];
    
    viewController.mainViewController = self.mainViewController;
    
    [self.mainViewController presentViewController:viewController fromDirection:SubViewDirectionRightToLeft];
    //[self.delegate didSelectLesson:lesson];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

#pragma mark - private stuff

- (NSString *)timeSpanStringWithStartDate:(NSTimeInterval)startTime andEndDate:(NSTimeInterval)endTime
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSString *startString = [format stringFromDate:startDate];
    NSString *endString = [format stringFromDate:endDate];
    
    int diffInSeconds = endTime - startTime;
    
    NSString *spanString;
    
    if (diffInSeconds <= 60)
    {
        spanString = [NSString stringWithFormat:@"%d Sekunden", diffInSeconds];
    }
    else 
    {
        spanString = [NSString stringWithFormat:@"%d Minuten", (int)((float)diffInSeconds / 60.0f)];
    }
    
    return [NSString stringWithFormat:@"%@ - %@  (%@)", startString, endString, spanString];
}

- (NSString *)scoreStringForInquiry:(Inquiry *)inquiry
{
    return [NSString stringWithFormat:@"%.00f%%", (inquiry.score * 100.0f)];
}

@end

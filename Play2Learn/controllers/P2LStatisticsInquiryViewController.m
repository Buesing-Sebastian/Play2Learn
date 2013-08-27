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
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height-60)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _heights = [NSMutableArray new];
        
        self.viewBuffer = [NSMutableArray new];
        
        NSArray *questions = [_inquiry.questions allObjects];
        
        for (int i = 0; i < _inquiry.questions.count; i++)
        {
            P2LStatisticsQuestionView *view = [[P2LStatisticsQuestionView alloc] initWithFrame:CGRectMake(0, 0, 768, 230)];
            view.row = i;
            view.delegate = self;
            view.question = [questions objectAtIndex:i];
            [_heights addObject:[NSNumber numberWithFloat:230]];
            [_viewBuffer addObject:view];
        }
        
        [self.view addSubview:_tableView];
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

//
//  P2LLessonSelectionViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LLessonSelectionViewController.h"
#import "Lesson+DBAPI.h"
#import "P2LModelManager.h"

@interface P2LLessonSelectionViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *lessons;

@end

@implementation P2LLessonSelectionViewController

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        CGRect tableViewFrame = CGRectMake(20, 55, self.view.frame.size.width - 40, self.view.frame.size.height - 40);
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
    
    self.lessons = [self.catalog.lessons allObjects];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView stuff

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"lesson";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Lesson *lesson = (Lesson *)[self.lessons objectAtIndex:indexPath.row];
    
    cell.textLabel.text = lesson.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lessons count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Lesson *lesson = (Lesson *)[self.lessons objectAtIndex:indexPath.row];
    
    [self.delegate didSelectLesson:lesson];
}

@end

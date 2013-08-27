//
//  P2LCatalogSelectionViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LCatalogSelectionViewController.h"
#import "P2LModelManager.h"
#import "Catalog+DBAPI.h"
#import "P2LCatalogMainViewController.h"

@interface P2LCatalogSelectionViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *catalogs;

@end

@implementation P2LCatalogSelectionViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        CGRect tableViewFrame = CGRectMake(20, 55, self.view.frame.size.width - 40, self.view.frame.size.height - 40);
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.backButton setImage:[UIImage imageNamed:@"back_top.png"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back_top_selected.png"] forState:UIControlStateHighlighted];
        
        // add subviews
        [self.view addSubview:self.tableView];
        
        [self reloadCatalogs];
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

#pragma mark - overrides

- (void)backButtonPressed
{
    [self.mainViewController dismissViewController:self fromDirection:SubViewDirectionTopToBottom];
}

#pragma mark - private stuff

- (void)reloadCatalogs
{
    self.catalogs = [P2LModelManager getAllEntitiesWithName:[Catalog entityName]];
    [self.tableView reloadData];
}

#pragma mark - UITableView stuff

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"catalog";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Catalog *catalog = (Catalog *)[self.catalogs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = catalog.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catalogs count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Catalog *selectedCatalog = [self.catalogs objectAtIndex:indexPath.row];
    
    if ([self.mainViewController isKindOfClass:[P2LMainViewController class]])
    {
        P2LMainViewController *mainController = (P2LMainViewController *)self.mainViewController;
        mainController.selectedCatalog = selectedCatalog;
        
        NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setInteger:mainController.selectedCatalog.primaryKey forKey:@"selectedCatalog"];
    }
    
    P2LCatalogMainViewController *controller = [[P2LCatalogMainViewController alloc] initWithFrame:self.view.frame];
    controller.catalog = selectedCatalog;
    controller.mainViewController = self.mainViewController;
    
    [self.mainViewController presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
}

@end

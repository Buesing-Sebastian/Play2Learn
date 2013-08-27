//
//  P2LCatalogsViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LCatalogsViewController.h"
#import "P2LCatalogDetailsViewController.h"
#import "P2LModelManager.h"
#import "Catalog+DBAPI.h"

@interface P2LCatalogsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) NSArray *catalogs;

@end

@implementation P2LCatalogsViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        CGRect tableViewFrame = CGRectMake(20, 55, self.view.frame.size.width - 40, self.view.frame.size.height - 40);
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        CGRect labelFrame = CGRectMake(0, 10, 200, 30);
        self.titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.titleLabel.text = @"Fragenkataloge";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.center = CGPointMake(self.view.center.x, 25);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
//        for ( NSString *familyName in [UIFont familyNames] )
//        {
//            NSLog(@"Family %@", familyName);
//            NSLog(@"Names = %@", [UIFont fontNamesForFamilyName:familyName]);
//        }
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.plusButton.frame = CGRectMake(self.view.frame.size.width - 94, 10, 84, 44);
        [self.plusButton setTitle:@"Neu" forState:UIControlStateNormal];
        [self.plusButton addTarget:self action:@selector(newButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // add subviews
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.titleLabel];
        [self.view addSubview:self.plusButton];
        
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

#pragma mark - private stuff

- (void)newButtonPressed
{
    P2LCatalogDetailsViewController *viewController = [[P2LCatalogDetailsViewController alloc] initWithFrame:self.view.frame andCatalog:nil];
    
    viewController.mainViewController = self;
    
    [self.mainViewController presentViewController:viewController fromDirection:SubViewDirectionRightToLeft];
}

- (void)reloadCatalogs
{
    self.catalogs = [P2LModelManager getAllEntitiesWithName:[Catalog entityName]];
    [self.tableView reloadData];
}

#pragma mark - P2LMainViewSubViewControllerDelegate methods

- (void)presentViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    [self.mainViewController presentViewController:viewController fromDirection:direction];
}

- (void)dismissViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    [self.mainViewController dismissViewController:viewController fromDirection:direction];
    
    [self reloadCatalogs];
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catalogs count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Catalog *catalog = (Catalog *)[self.catalogs objectAtIndex:indexPath.row];
    
    P2LCatalogDetailsViewController *viewController = [[P2LCatalogDetailsViewController alloc] initWithFrame:self.view.frame andCatalog:catalog];
    
    viewController.mainViewController = self;
    
    [self.mainViewController presentViewController:viewController fromDirection:SubViewDirectionRightToLeft];
}

@end

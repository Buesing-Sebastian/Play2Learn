//
//  P2LMainViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LMainViewController.h"
#import "P2LCatalogSelectionViewController.h"
#import "P2LCatalogsViewController.h"
#import "P2LCatalogMainViewController.h"
#import "P2LLatexXMLConverter.h"
#import "P2LQTIImporter.h"

@interface P2LMainViewController ()

@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *catalogSettingsButton;
@property (nonatomic, strong) UIButton *catalogSelectionButton;
@property (nonatomic, strong) UIImageView *logo;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *viewControllerStack;

@end

@implementation P2LMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[P2LLatexXMLConverter parseFile:[[NSBundle mainBundle] pathForResource:@"chapter1" ofType:@"tex"]];
    // set up view
    //self.view.backgroundColor = [UIColor colorWithRed:0.043f green:0.192f blue:0.63f alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize thisSize = self.view.frame.size;
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
    self.hintLabel.center = CGPointMake(self.view.center.x, thisSize.height - 150);
    self.hintLabel.text = @"";
    self.hintLabel.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"chrome.png"];
    self.logo = [[UIImageView alloc] initWithImage:image];
    self.logo.center = self.view.center;
    
    // setup buttons
    self.catalogSelectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.catalogSelectionButton.frame = CGRectMake(20, thisSize.height - 100, 100, 44);
    [self.catalogSelectionButton setTitle:@"Auswählen" forState:UIControlStateNormal];
    
    self.catalogSettingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.catalogSettingsButton.frame = CGRectMake(thisSize.width - 120, thisSize.height - 100, 100, 44);
    [self.catalogSettingsButton setTitle:@"Verwalten" forState:UIControlStateNormal];
    
    // connect buttons
    [self.catalogSelectionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.catalogSettingsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // create content view
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thisSize.width, thisSize.height)];
    [self.contentView addSubview:self.hintLabel];
    [self.contentView addSubview:self.catalogSettingsButton];
    [self.contentView addSubview:self.catalogSelectionButton];
    [self.contentView addSubview:self.logo];
    
    // create the viewController stack
    self.viewControllerStack = [NSMutableArray new];
    [self.viewControllerStack addObject:self];
    
    [self.view addSubview:self.contentView];
    
    // restore state
    int selectedId = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedCatalog"];
    
    if (selectedId)
    {
        Catalog *selectedCatalog = (Catalog *)[Catalog findModelWithPrimaryKey:selectedId];
        
        if (selectedCatalog)
        {
            [self restoreStateWithCatalog:selectedCatalog];
        }
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)restoreStateWithCatalog:(Catalog *)selectedCatalog
{
    self.selectedCatalog = selectedCatalog;
    
    P2LCatalogSelectionViewController *controller = [[P2LCatalogSelectionViewController alloc] initWithFrame:self.contentView.frame];
    controller.mainViewController = self;
    
    [self presentViewController:controller fromDirection:SubViewDirectionBottomToTop];
    
    P2LCatalogMainViewController *mainController = [[P2LCatalogMainViewController alloc] initWithFrame:self.view.frame];
    mainController.catalog = selectedCatalog;
    mainController.mainViewController = self;
    
    [self presentViewController:mainController fromDirection:SubViewDirectionRightToLeft];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (sender == self.catalogSettingsButton)
    {
        P2LCatalogsViewController *controller = [[P2LCatalogsViewController alloc] initWithFrame:self.contentView.frame];
        controller.mainViewController = self;
        
        [self presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
    }
    else if (sender == self.catalogSelectionButton)
    {
        P2LCatalogSelectionViewController *controller = [[P2LCatalogSelectionViewController alloc] initWithFrame:self.contentView.frame];
        controller.mainViewController = self;
        
        [self presentViewController:controller fromDirection:SubViewDirectionBottomToTop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - P2LMainViewSubViewControllerDelegate methods

- (void)presentViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    UIView *currentView;
    UIView *nextView = viewController.view;
    
    if (self.viewControllerStack.count == 1)
    {
        currentView = self.contentView;
    }
    else
    {
        UIViewController *controller = [self.viewControllerStack lastObject];
        currentView = controller.view;
    }

    switch (direction)
    {
        case SubViewDirectionRightToLeft:
        {
            nextView.frame = CGRectMake(self.view.frame.size.width, 0, nextView.frame.size.width, nextView.frame.size.height);
            [self.view addSubview:nextView];
        
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
                currentView.frame = CGRectMake(-self.view.frame.size.width, 0, currentView.frame.size.width, currentView.frame.size.height);
                nextView.frame = CGRectMake(0, 0, nextView.frame.size.width, nextView.frame.size.height);
            
            } completion:^(BOOL finished){
            
                [currentView removeFromSuperview];
                [self.viewControllerStack addObject:viewController];
            
            }];
        }
        break;
        
        case SubViewDirectionLeftToRight:
        
        break;
        
        case SubViewDirectionBottomToTop:
        {
            nextView.frame = CGRectMake(0, self.view.frame.size.height, nextView.frame.size.width, nextView.frame.size.height);
            [self.view addSubview:nextView];
            
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                
                currentView.frame = CGRectMake(0, -self.view.frame.size.height, currentView.frame.size.width, currentView.frame.size.height);
                nextView.frame = CGRectMake(0, 0, nextView.frame.size.width, nextView.frame.size.height);
                
            } completion:^(BOOL finished){
                
                [currentView removeFromSuperview];
                [self.viewControllerStack addObject:viewController];
                
            }];
        }
        break;
        
        case SubViewDirectionTopToBottom:
        
        break;
    }
}
- (void)dismissViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    if (self.viewControllerStack.count >= 2 && [self.viewControllerStack lastObject] == viewController)
    {
        UIView *currentView = viewController.view;
        
        UIViewController *nextViewController = [self.viewControllerStack objectAtIndex:self.viewControllerStack.count-2];
        UIView *nextView;
        
        if (self.viewControllerStack.count == 2)
        {
            nextView = self.contentView;
        }
        else
        {
            nextView = nextViewController.view;
        }
        
        switch (direction)
        {
            case SubViewDirectionRightToLeft:
            {
                
            }
                break;
                
            case SubViewDirectionLeftToRight:
            {
                nextView.frame = CGRectMake(-self.view.frame.size.width, 0, nextView.frame.size.width, nextView.frame.size.height);
                [self.view addSubview:nextView];
                
                [UIView animateWithDuration:0.2f animations:^(){
                    
                    currentView.frame = CGRectMake(self.view.frame.size.width, 0, currentView.frame.size.width, currentView.frame.size.height);
                    nextView.frame = CGRectMake(0, 0, nextView.frame.size.width, nextView.frame.size.height);
                    
                } completion:^(BOOL finished){
                    
                    [currentView removeFromSuperview];
                    [self.viewControllerStack removeLastObject];
                    
                }];
            }
                break;
                
            case SubViewDirectionBottomToTop:
                
                break;
                
            case SubViewDirectionTopToBottom:
            {
                nextView.frame = CGRectMake(0, -self.view.frame.size.height, nextView.frame.size.width, nextView.frame.size.height);
                [self.view addSubview:nextView];
                
                [UIView animateWithDuration:0.2f animations:^(){
                    
                    currentView.frame = CGRectMake(0, self.view.frame.size.height, currentView.frame.size.width, currentView.frame.size.height);
                    nextView.frame = CGRectMake(0, 0, nextView.frame.size.width, nextView.frame.size.height);
                    
                } completion:^(BOOL finished){
                    
                    [currentView removeFromSuperview];
                    [self.viewControllerStack removeLastObject];
                    
                }];
            }
                break;
        }
    }
}

@end

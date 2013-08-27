//
//  P2LBaseViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LBaseViewController.h"

@interface P2LBaseViewController ()

@end

@implementation P2LBaseViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        self.view = [[UIView alloc] initWithFrame:frame];
        //self.view.backgroundColor = [UIColor colorWithRed:0.043f green:0.192f blue:0.63f alpha:1];
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(10, 10, 44, 44);
        [self.backButton setImage:[UIImage imageNamed:@"back2x.png"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back_selected2x.png"] forState:UIControlStateHighlighted];
        [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.backButton];
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

- (void)backButtonPressed
{
    [self.mainViewController dismissViewController:self fromDirection:SubViewDirectionLeftToRight];
}

@end

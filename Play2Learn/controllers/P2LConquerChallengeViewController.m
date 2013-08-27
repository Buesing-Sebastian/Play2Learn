//
//  P2LConquerChallengeViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 26.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LConquerChallengeViewController.h"
#import "P2LConquerViewController.h"

@interface P2LConquerChallengeViewController ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *vsLabel;
@property (nonatomic, strong) UILabel *requirementLabel;

@end

@implementation P2LConquerChallengeViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(self.view.frame.size.width - 54, 10, 44, 44);
        [self.cancelButton addTarget:self.delegate action:@selector(challangeCanceled) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel_selected.png"] forState:UIControlStateHighlighted];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.titleLabel.text = @"Gebiet angreifen";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.center = CGPointMake(self.view.center.x, 25);
        
        self.vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.vsLabel.text = @"VS";
        self.vsLabel.textAlignment = NSTextAlignmentCenter;
        self.vsLabel.center = CGPointMake(self.view.center.x, self.view.center.y-100);;
        
        self.requirementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        self.requirementLabel.text = @"__% richtige Antworten benötigt";
        self.requirementLabel.textAlignment = NSTextAlignmentCenter;
        self.requirementLabel.center = CGPointMake(self.view.center.x, 800);
        
        self.acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.acceptButton.frame = CGRectMake(0, 0, 150, 44);
        [self.acceptButton addTarget:self.delegate action:@selector(challangeAccepted) forControlEvents:UIControlEventTouchUpInside];
        [self.acceptButton setTitle:@"Attacke!" forState:UIControlStateNormal];
        self.acceptButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 60);
        
        [self.backButton removeFromSuperview];
        
        self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        [self.view addSubview:self.cancelButton];
        [self.view addSubview:self.acceptButton];
        [self.view addSubview:self.titleLabel];
        [self.view addSubview:self.vsLabel];
        [self.view addSubview:self.requirementLabel];
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

- (void)beginAnimations
{
    NSMutableArray *ownForces = [NSMutableArray new];
    
    CGFloat width = self.view.frame.size.width - 20.0f;
    CGFloat myForcesY = 200.0f;
    
    
    CGFloat xOffset = width / self.numOwnForces;
    CGFloat startX = xOffset / 2.0f;
    
    for (int i = 0; i < self.numOwnForces; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warrior.png"]];
        
        imageView.center = CGPointMake(startX, myForcesY);
        imageView.alpha = 0.0f;
        
        startX += xOffset;
        
        [ownForces addObject:imageView];
        
        [self.view addSubview:imageView];
    }
    
    NSMutableArray *enemyForces = [NSMutableArray new];
    CGFloat enemyForcesY = 600;
    
    
    xOffset = width / self.numEnemyForces;
    startX = xOffset / 2.0f;
    
    for (int i = 0; i < self.numEnemyForces; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warrior.png"]];
        
        imageView.center = CGPointMake(startX , enemyForcesY);
        imageView.alpha = 0.0f;
        
        startX += xOffset;
        
        [enemyForces addObject:imageView];
        
        [self.view addSubview:imageView];
    }
    float delay = 0.1f;
    
    for (UIImageView *imageView in ownForces)
    {
        [UIView animateWithDuration:0.1f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            
            imageView.alpha = 1.0f;
            
        } completion:nil];
        
        delay += 0.1f;
    }
    
    for (UIImageView *imageView in enemyForces)
    {
        [UIView animateWithDuration:0.1f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
            imageView.alpha = 1.0f;
        
        } completion:nil];
    
        delay += 0.1f;
    }
    
    CGFloat percentNeeded = [self correctnessRequired];
    
    [UIView animateWithDuration:0.1f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.requirementLabel.text = [NSString stringWithFormat:@"%.02f Prozent richtige Antworten benötigt", percentNeeded];
        
    } completion:nil];
}

- (CGFloat)correctnessRequired
{
    return MIN(100.0f, MAX(50.0f, ((float)self.numEnemyForces / (float)self.numOwnForces) * 100.0f));
}

@end

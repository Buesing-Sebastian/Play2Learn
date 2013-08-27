//
//  P2LCatalogMainViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LCatalogMainViewController.h"
#import "P2LLessonSelectionViewController.h"
#import "P2LInquiryViewController.h"
#import "P2LConquerViewController.h"
#import "P2LPathDebugViewController.h"
#import "P2LLatexXMLConverter.h"
#import "P2LStatisticsViewController.h"

typedef enum CatalogPlayMode
{
    CatalogPlayModeTrain,
    CatalogPlayModeConquer
}
CatalogPlayMode;

@interface P2LCatalogMainViewController ()

@property (nonatomic, strong) UIButton *trainButton;
@property (nonatomic, strong) UIButton *conquerButton;
@property (nonatomic, strong) UIButton *shopButton;
@property (nonatomic, strong) UIButton *statsButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CatalogPlayMode currentMode;

@end

@implementation P2LCatalogMainViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        CGFloat offSet = self.view.frame.size.width / 10.0f;
        CGFloat width = (self.view.frame.size.width - offSet * 3 ) / 2.0;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"";
        self.titleLabel.center = CGPointMake(self.view.center.x, 20);
        
        [self.view addSubview:self.titleLabel];
        
        self.trainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.trainButton setImage:[UIImage imageNamed:@"train.png"] forState:UIControlStateNormal];
        [self.trainButton setImage:[UIImage imageNamed:@"train_selected.png"] forState:UIControlStateHighlighted];
        self.trainButton.frame = CGRectMake(offSet, offSet+30, width, width);
        [self.trainButton addTarget:self action:@selector(trainButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.trainButton];
        
        self.conquerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.conquerButton setImage:[UIImage imageNamed:@"conquer.png"] forState:UIControlStateNormal];
        [self.conquerButton setImage:[UIImage imageNamed:@"conquer_selected.png"] forState:UIControlStateHighlighted];
        self.conquerButton.frame = CGRectMake((self.view.frame.size.width - offSet - width), offSet+30, width, width);
        [self.conquerButton addTarget:self action:@selector(conquerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.conquerButton];
        
        self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shopButton setImage:[UIImage imageNamed:@"shop.png"] forState:UIControlStateNormal];
        [self.shopButton setImage:[UIImage imageNamed:@"shop_selected.png"] forState:UIControlStateHighlighted];
        self.shopButton.frame = CGRectMake(offSet, ((2 * offSet) + width + 30), width, width);
        [self.shopButton addTarget:self action:@selector(shopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.shopButton];
        
        self.statsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.statsButton setImage:[UIImage imageNamed:@"stats.png"] forState:UIControlStateNormal];
        [self.statsButton setImage:[UIImage imageNamed:@"stats_selected.png"] forState:UIControlStateHighlighted];
        self.statsButton.frame = CGRectMake((self.view.frame.size.width - offSet - width), ((2 * offSet) + width + 30), width, width);
        [self.statsButton addTarget:self action:@selector(statsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.statsButton];
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

- (void)setCatalog:(Catalog *)catalog
{
    _catalog = catalog;
    
    self.titleLabel.text = catalog.name;
}

#pragma mark - P2LLessonSelectionDelegate methods

- (void)didSelectLesson:(Lesson *)lesson
{
    switch (self.currentMode)
    {
        case CatalogPlayModeTrain:
        {
            Inquiry *inquiry = [[Inquiry alloc] initEntity];
            inquiry.questions = lesson.questions;
            inquiry.lesson = lesson;
            
            P2LInquiryViewController *controller = [[P2LInquiryViewController alloc] initWithInquiry:inquiry andFrame:self.view.frame];
            controller.mainViewController = self.mainViewController;
            [self.mainViewController presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
            
            [inquiry save];
            [controller startInquiry];
        }
            break;
            
        case CatalogPlayModeConquer:
        {
            
            P2LConquerViewController *controller = [[P2LConquerViewController alloc] initWithFrame:self.view.frame];
            controller.mainViewController = self.mainViewController;
            controller.lesson = lesson;
            
            [self.mainViewController presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
            
            // start the game after the viewController is animated onto the view.
            [controller performSelector:@selector(startGame) withObject:controller afterDelay:0.3f];
        }
            break;
    }
}


#pragma mark - private stuff

- (void)trainButtonClicked
{
    self.currentMode = CatalogPlayModeTrain;
    
    [self displayLessonSelection];
}

- (void)conquerButtonClicked
{
    self.currentMode = CatalogPlayModeConquer;
    
    [self displayLessonSelection];
}

- (void)shopButtonClicked
{
    [P2LLatexXMLConverter parseExportedLyxFile:[[NSBundle mainBundle] pathForResource:@"Fragenkatalog" ofType:@"tex"]];
}

- (void)statsButtonClicked
{
    P2LStatisticsViewController *controller = [[P2LStatisticsViewController alloc] initWithFrame:self.view.frame andCatalog:self.catalog];
    controller.mainViewController = self.mainViewController;
    
    [self.mainViewController presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
}

- (void)displayLessonSelection
{
    P2LLessonSelectionViewController *controller = [[P2LLessonSelectionViewController alloc] initWithFrame:self.view.frame andCatalog:self.catalog];
    controller.mainViewController = self.mainViewController;
    controller.delegate = self;
    
    [self.mainViewController presentViewController:controller fromDirection:SubViewDirectionRightToLeft];
}

@end

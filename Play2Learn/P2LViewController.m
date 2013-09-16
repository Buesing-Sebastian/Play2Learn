//
//  P2LViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LViewController.h"
#import "P2LPathView.h"
#import "P2LGraphPathGenerator.h"
#import "P2LQTIImporter.h"
#import "P2LMathMLView.h"
#import "Lesson+DBAPI.h"
#import "Inquiry+DBAPI.h"
#import "P2LInquiryViewController.h"

@interface P2LViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation P2LViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    Lesson *lessonA = (Lesson *)[Lesson findModelWithPrimaryKey:1];
//    Lesson *lessonB = (Lesson *)[Lesson findModelWithPrimaryKey:2];
//    
//    Inquiry *inquiry = [[Inquiry alloc] initEntity];
//    
//    //inquiry.questions = lessonA.questions;
//    inquiry.questions = [lessonA.questions setByAddingObjectsFromSet:lessonB.questions];
//    
//    P2LInquiryController *controller = [[P2LInquiryController alloc] initWithInquiry:inquiry];
//    
//    controller.view.frame = self.view.frame;
//    [self.view addSubview:controller.view];
//    [controller startInquiry];
//
//    [inquiry save];
    
    
//    
//    UIWebView *htmlView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 400)];
//    [htmlView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample-tex" ofType:@"html" inDirectory:@"MathJax/test"]isDirectory:NO]]];
//    [htmlView setScalesPageToFit:YES];
//    
    P2LMathMLView *mathView = [[P2LMathMLView alloc] initWithFrame:CGRectMake(0, 0, 700, 500)];
    
    mathView.latexCode = @"When $a \\ne 0$, there are two solutions <br /> to \\(ax^2 + bx + c = 0\\) and they are \n$$x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}.$$";
    
	[self.view addSubview:mathView];
    
//	[self.view addSubview:htmlView];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Testdatei" ofType:@"xml"];
//    [P2LQTIImporter importDataFromFile:filePath];
    
//    self.numVertices = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 40, 40)];
//    self.numVertices.text = @"6";
//    
//    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(195, 20)];
//    
//    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
//    
//    [path addEdgeToEndPoint:CGPointMake(190, 170)];
//    [path addEdgeToEndPoint:CGPointMake(30, 190)];
//    [path closePath];
//    
//    //P2LPathView *pathView = [[P2LPathView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andPath:path];
    
    _areas = [NSMutableArray new];
//
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    scrollView.contentSize = CGSizeMake(2000, 2000);

    
    CGRect randomRect = CGRectMake(0, 0, 400, 400);
    
    P2LGraphPath *randomPath = [P2LGraphPathGenerator generatePathInsideRect:randomRect withEdgesCount:20];
    [randomPath movePointsWithXOffset:1000 andYOffset:1000];
    //P2LGraphPath *randomPath = [P2LGraphPathGenerator generatePathWithRadius:350.0f minLength:200.0f fromAngle:90.0f toAngle:180 withNumEdges:25];
    
    NSArray *firstLevel = [P2LGraphPathGenerator generatePathsAroundPath:randomPath withMaxLength:800 andNumPaths:5];
    
    CGRect contentRect = CGRectMake(0, 0, 2000, 2000);
    self.contentView = [[UIView alloc] initWithFrame:contentRect];
    
    self.randomView = [[P2LPathView alloc] initWithFrame:contentRect andPath:randomPath];
    self.randomView.alpha = 0.5;
    self.randomView.selected = YES;
    self.selectedView = self.randomView;
    
    [_areas addObject:self.randomView];
    
    for (P2LGraphPath *path in firstLevel)
    {
        P2LPathView *pathView = [[P2LPathView alloc] initWithFrame:contentRect andPath:path];
        [self.contentView addSubview:pathView];
        
        [_areas addObject:pathView];
    }
    
    [self.contentView addSubview:self.randomView];
    [scrollView addSubview:self.contentView];
    
    scrollView.minimumZoomScale = 0.25;
    scrollView.maximumZoomScale = 2.0;

    scrollView.delegate = self;
    
    CGPoint randomMid = [randomPath midPoint];
    CGSize randomBounds = [randomPath boundsSize];
    CGRect innerRect = CGRectMake(randomMid.x - (randomBounds.width / 2.0f), randomMid.y - (randomBounds.height / 2.0f), randomBounds.width, randomBounds.height);
    
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
    
        scrollView.zoomScale = 0.55;
        
    } completion:^(BOOL finished){
    
        [scrollView scrollRectToVisible:innerRect animated:YES];
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    [self.contentView addGestureRecognizer:recognizer];
//
//    UIButton *random = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [random setTitle:@"Zufall!" forState:UIControlStateNormal];
//    random.frame = CGRectMake(200, 5, 100, 40);
//    [random addTarget:self action:@selector(random:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *oneUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [oneUp setTitle:@"+" forState:UIControlStateNormal];
//    oneUp.frame = CGRectMake(5, 5, 40, 40);
//    [oneUp addTarget:self action:@selector(oneUp:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *oneDown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [oneDown setTitle:@"-" forState:UIControlStateNormal];
//    oneDown.frame = CGRectMake(80, 5, 40, 40);
//    [oneDown addTarget:self action:@selector(oneDown:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:random];
//    [self.view addSubview:self.numVertices];
//    [self.view addSubview:oneUp];
//    [self.view addSubview:oneDown];
    
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.contentView];
    
    for (P2LPathView *pathView in _areas)
    {
        if ([pathView.path isInsidePoint:location])
        {
            self.selectedView.selected = NO;
            [self.selectedView setNeedsDisplay];
            
            pathView.selected = YES;
            self.selectedView = pathView;
            [self.selectedView setNeedsDisplay];
        }
    }
}

- (void)random:(UIButton *)sender
{
    CGRect randomRect = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    P2LGraphPath *randomPath = [P2LGraphPathGenerator generatePathInsideRect:randomRect withEdgesCount:[self.numVertices.text intValue]];
    
    [self.randomView setPath:randomPath];
    [self.randomView setNeedsDisplay];
}

- (void)oneUp:(UIButton *)sender
{
    int value = [self.numVertices.text intValue];
    
    value++;
    
    self.numVertices.text = [NSString stringWithFormat:@"%d", value];
}

- (void)oneDown:(UIButton *)sender
{
    int value = [self.numVertices.text intValue];
    
    value = MAX(3, value-1);
    
    self.numVertices.text = [NSString stringWithFormat:@"%d", value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

@end

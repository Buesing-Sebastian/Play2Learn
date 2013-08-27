//
//  P2LPathDebugViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 30.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LPathDebugViewController.h"
#import "P2LPathView.h"

@interface P2LPathDebugViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation P2LPathDebugViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.contentSize = CGSizeMake(3000, 3000);
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3000, 3000)];
        
        [self.scrollView addSubview:self.contentView];
        [self.view addSubview:self.scrollView];
        
        NSString *file1 = [[NSBundle mainBundle] pathForResource:@"path1" ofType:@"path"];
        NSString *path1String = [NSString stringWithContentsOfFile:file1 encoding:NSUTF8StringEncoding error:nil];
        NSString *file2 = [[NSBundle mainBundle] pathForResource:@"path2" ofType:@"path"];
        NSString *path2String = [NSString stringWithContentsOfFile:file2 encoding:NSUTF8StringEncoding error:nil];
        NSString *file3 = [[NSBundle mainBundle] pathForResource:@"path3" ofType:@"path"];
        NSString *path3String = [NSString stringWithContentsOfFile:file3 encoding:NSUTF8StringEncoding error:nil];
        
        NSMutableArray *points = [NSMutableArray new];
        
        NSArray *lines = [path1String componentsSeparatedByString:@"\n"];
        
        for (__strong NSString *line in lines)
        {
            NSRange range = [line rangeOfString:@"("];
            int start = range.location + 1;
            range = [line rangeOfString:@")"];
            int end = range.location;
            line = [line substringWithRange:NSMakeRange(start, end - start)];
            
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            CGPoint point = CGPointMake([[components objectAtIndex:0] floatValue], [[components objectAtIndex:1] floatValue]);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        P2LGraphPath *path1 = [[P2LGraphPath alloc] initWithPoints:points];
        
        points = [NSMutableArray new];
        
        lines = [path2String componentsSeparatedByString:@"\n"];
        
        for (__strong NSString *line in lines)
        {
            NSRange range = [line rangeOfString:@"("];
            int start = range.location + 1;
            range = [line rangeOfString:@")"];
            int end = range.location;
            line = [line substringWithRange:NSMakeRange(start, end - start)];
            
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            CGPoint point = CGPointMake([[components objectAtIndex:0] floatValue], [[components objectAtIndex:1] floatValue]);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        P2LGraphPath *path2 = [[P2LGraphPath alloc] initWithPoints:points];
        
        points = [NSMutableArray new];
        
        lines = [path3String componentsSeparatedByString:@"\n"];
        
        for (__strong NSString *line in lines)
        {
            NSRange range = [line rangeOfString:@"("];
            int start = range.location + 1;
            range = [line rangeOfString:@")"];
            int end = range.location;
            line = [line substringWithRange:NSMakeRange(start, end - start)];
            
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            CGPoint point = CGPointMake([[components objectAtIndex:0] floatValue], [[components objectAtIndex:1] floatValue]);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        P2LGraphPath *path3 = [[P2LGraphPath alloc] initWithPoints:points];
        
        [path1 closePath];
        //[path2 closePath];
        //[path3 closePath];
        
        P2LPathView *view1 = [[P2LPathView alloc] initWithFrame:CGRectMake(0, 0, 3000, 3000) andPath:path1];
        P2LPathView *view2 = [[P2LPathView alloc] initWithFrame:CGRectMake(0, 0, 3000, 3000) andPath:path2];
        P2LPathView *view3 = [[P2LPathView alloc] initWithFrame:CGRectMake(0, 0, 3000, 3000) andPath:path3];
        view2.alpha = 0.5;
        view2.strokeWidth = 6;
        view2.pathColor = [UIColor blueColor];
        view3.alpha = 0.2;
        view3.pathColor = [UIColor greenColor];
        view3.strokeWidth = 12;
        
        [self.contentView addSubview:view1];
        [self.contentView addSubview:view2];
        [self.contentView addSubview:view3];
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

@end

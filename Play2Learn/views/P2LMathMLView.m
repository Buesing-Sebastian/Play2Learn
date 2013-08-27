//
//  P2LMathMLView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 05.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LMathMLView.h"

@interface P2LMathMLView ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *htmlLayout;

@end

@implementation P2LMathMLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect webFrame = frame;
        
        webFrame.origin.x = 0;
        webFrame.origin.y = 0;
        
        self.webView = [[UIWebView alloc] initWithFrame:webFrame];
        self.webView.delegate = self;
        
        [self addSubview:self.webView];
        
        self.htmlLayout = [self loadHtmlLayout];
        
        self.backgroundColor = [UIColor magentaColor];
    }
    return self;
}

- (NSString *)loadHtmlLayout
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"latexLayout" ofType:@"html"];
    NSError *error;
    return [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
}

#pragma mark - getter/setter

- (void)setLatexCode:(NSString *)latexCode
{
    _latexCode = latexCode;
    
    NSString *html = [self.htmlLayout stringByReplacingOccurrencesOfString:@"{{LAXTEX_PLACEHOLDER}}" withString:self.latexCode];
    html = [html stringByReplacingOccurrencesOfString:@"{{FONT_SIZE_PLACEHOLDER}}" withString:@"1.5"];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/MathJax"];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [self.webView loadHTMLString:html baseURL:baseURL];
    
    //[self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:url];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect webFrame = self.webView.frame;
    
    webFrame.size.width = frame.size.width;
    webFrame.size.height = frame.size.height;
    
    self.webView.frame = webFrame;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request);
    
    return YES;
}

@end

//
//  P2LMathMLView.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 05.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P2LMathMLView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) NSString *latexCode;

@end

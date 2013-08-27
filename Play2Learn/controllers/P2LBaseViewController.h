//
//  P2LBaseViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LMainViewController.h"

@interface P2LBaseViewController : UIViewController

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, weak) id<P2LMainViewSubViewControllerDelegate> mainViewController;

- (id)initWithFrame:(CGRect)frame;

@end

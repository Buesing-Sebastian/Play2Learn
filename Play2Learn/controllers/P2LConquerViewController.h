//
//  P2LConquerViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LBaseViewController.h"
#import "P2LInquiryViewControllerDelegate.h"
#import "Lesson.h"

@interface P2LConquerViewController : P2LBaseViewController <UIScrollViewDelegate, P2LMainViewSubViewControllerDelegate, P2LInquiryViewControllerDelegate>

@property (nonatomic, strong) Lesson *lesson;

- (void)startGame;

// methods called from the P2LConquerChallangeViewController
- (void)challangeAccepted;
- (void)challangeCanceled;

@end

//
//  P2LQuestionView.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LInquiryViewController.h"

@interface P2LQuestionView : UIScrollView

@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) P2LInquiryViewController *controller;

- (void)enableNextButton;
- (void)disableSubmitButton;

- (void)enableInteraction;
- (void)disableInteraction;

- (void)setNote:(NSString *)note forAnswerAtIndex:(int)index;
- (BOOL)checkedAnswerAtIndex:(int)index;

@end

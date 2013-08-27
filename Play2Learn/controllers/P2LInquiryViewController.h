//
//  P2LInquiryController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2LBaseViewController.h"
#import "P2LInquiryViewControllerDelegate.h"
#import "Inquiry+DBAPI.h"

@interface P2LInquiryViewController : P2LBaseViewController

@property (nonatomic, strong) Inquiry *inquiry;
@property (nonatomic, weak) id<P2LInquiryViewControllerDelegate> delegate;

- (id)initWithInquiry:(Inquiry *)inquiry andFrame:(CGRect)frame;

- (void)startInquiry;
- (void)nextQuestion;
- (void)submitQuestion;

@end

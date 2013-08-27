//
//  P2LInquiryController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Inquiry+DBAPI.h"

@interface P2LInquiryController : NSObject

@property (nonatomic, strong) Inquiry *inquiry;
@property (nonatomic, strong) UIView *view;

- (id)initWithInquiry:(Inquiry *)inquiry;

- (void)startInquiry;
- (void)nextQuestion;
- (void)submitQuestion;

@end

//
//  P2LStatisticsInquiryViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LBaseViewController.h"
#import "Inquiry+DBAPI.h"

@interface P2LStatisticsInquiryViewController : P2LBaseViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithFrame:(CGRect)frame andInquiry:(Inquiry *)inquiry;

- (void)setHeight:(CGFloat)height forRow:(int)row;

@end

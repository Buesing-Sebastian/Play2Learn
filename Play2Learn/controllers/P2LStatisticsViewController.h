//
//  P2LStatisticsViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 11.08.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LBaseViewController.h"

@interface P2LStatisticsViewController : P2LBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Catalog *catalog;

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog;

@end

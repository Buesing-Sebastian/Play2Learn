//
//  P2LCatalogDetailsViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LBaseViewController.h"
#import "Catalog+DBAPI.h"

@interface P2LCatalogDetailsViewController : P2LBaseViewController

@property (nonatomic, strong) Catalog *catalog;

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog;

@end

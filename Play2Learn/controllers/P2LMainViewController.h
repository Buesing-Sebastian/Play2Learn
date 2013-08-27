//
//  P2LMainViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LMainViewSubViewControllerDelegate.h"
#import "Catalog+DBAPI.h"

@interface P2LMainViewController : UIViewController <P2LMainViewSubViewControllerDelegate>

@property (nonatomic, strong) Catalog *selectedCatalog;

@end

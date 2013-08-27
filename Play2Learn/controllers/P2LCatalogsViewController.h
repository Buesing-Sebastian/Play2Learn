//
//  P2LCatalogsViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LBaseViewController.h"
#import "P2LMainViewSubViewControllerDelegate.h"

@interface P2LCatalogsViewController : P2LBaseViewController <P2LMainViewSubViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@end

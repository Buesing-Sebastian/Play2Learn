//
//  P2LCatalogMainViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog+DBAPI.h"
#import "P2LBaseViewController.h"
#import "P2LLessonSelectionDelegate.h"

@interface P2LCatalogMainViewController : P2LBaseViewController <P2LLessonSelectionDelegate>

@property (nonatomic, strong) Catalog *catalog;

@end

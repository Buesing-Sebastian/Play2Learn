//
//  P2LLessonSelectionViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LBaseViewController.h"
#import "P2LLessonSelectionDelegate.h"
#import "Catalog+DBAPI.h"

@interface P2LLessonSelectionViewController : P2LBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Catalog *catalog;
@property (nonatomic, weak) id<P2LLessonSelectionDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog;

@end

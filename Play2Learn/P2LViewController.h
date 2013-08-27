//
//  P2LViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LPathView.h"

@interface P2LViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) P2LPathView *randomView;
@property (nonatomic, strong) P2LPathView *selectedView;

@property (nonatomic, strong) NSMutableArray *areas;

@property (nonatomic, strong) UILabel *numVertices;

@end

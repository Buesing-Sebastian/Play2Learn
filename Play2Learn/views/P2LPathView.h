//
//  P2LPathView.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LGraphPath.h"

@interface P2LPathView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) P2LGraphPath *path;
@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat forcesCount;
@property (nonatomic, assign) BOOL occupiedByEnemy;
@property (nonatomic, strong) UILabel *forcesLabel;

- (id)initWithFrame:(CGRect)frame andPath:(P2LGraphPath *)path;


@end

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

/*
 * Holds selection state used in conquer mode. A selected view
 * is drawn differently. see -(void)drawRect:(CGRect)rect
 */
@property (nonatomic, assign) BOOL selected;
/*
 * Stores the path object to be drawn on the view.
 */
@property (nonatomic, strong) P2LGraphPath *path;
/*
 * Color with which the path is drawn.
 */
@property (nonatomic, strong) UIColor *pathColor;
/*
 * Width of the path (in points).
 */
@property (nonatomic, assign) CGFloat strokeWidth;
/*
 * Number of units that are on the polygon (path).
 */
@property (nonatomic, assign) CGFloat forcesCount;
/*
 * Determines wether the area (that the view represents)
 * is occupied by the enemy or the user.
 */
@property (nonatomic, assign) BOOL occupiedByEnemy;
/*
 * A Label that displays the number of units on this area.
 */
@property (nonatomic, strong) UILabel *forcesLabel;
/*
 * Default initializer.
 */
- (id)initWithFrame:(CGRect)frame andPath:(P2LGraphPath *)path;

@end

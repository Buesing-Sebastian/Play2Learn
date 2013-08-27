//
//  P2LConquerChallengeViewController.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 26.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LBaseViewController.h"

@class P2LConquerViewController;

@interface P2LConquerChallengeViewController : P2LBaseViewController

@property (nonatomic, assign) int numOwnForces;
@property (nonatomic, assign) int numEnemyForces;

@property (nonatomic, weak) P2LConquerViewController *delegate;

- (void)beginAnimations;
- (CGFloat)correctnessRequired;

@end

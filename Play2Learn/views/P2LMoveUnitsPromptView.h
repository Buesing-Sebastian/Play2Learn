//
//  P2LMoveUnitsPromptView.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.07.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P2LMoveUnitsPromptView : UIView

@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) NSUInteger maxCount;
@property (nonatomic, assign) NSUInteger unitCount;

@end

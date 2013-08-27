//
//  P2LMoveUnitsPromptView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.07.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "P2LMoveUnitsPromptView.h"

@interface P2LMoveUnitsPromptView ()

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *minusButton;

@end

@implementation P2LMoveUnitsPromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backgroundView.alpha = 0.5f;
        backgroundView.backgroundColor = [UIColor grayColor];
        [self addSubview:backgroundView];
        
        CGFloat width, height;
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
        self.plusButton.frame = CGRectMake(25.0, self.center.y + 15, 40, 40);
        [self.plusButton addTarget:self action:@selector(plusClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
        self.minusButton.frame = CGRectMake(25.0, self.center.y - 55, 40, 40);
        [self.minusButton addTarget:self action:@selector(minusClicked) forControlEvents:UIControlEventTouchUpInside];
        
        width = frame.size.width - 40;
        height = 20.0f;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.textField.center = self.center;
        self.textField.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        self.textField.textAlignment = NSTextAlignmentCenter;
        
        self.acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.acceptButton setTitle:@"Bewegen" forState:UIControlStateNormal];
        self.acceptButton.frame = CGRectMake(self.frame.size.width - 125, self.center.y + 15, 100, 40);
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.cancelButton setTitle:@"Abbrechen" forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(self.frame.size.width - 125, self.center.y - 55, 100, 40);
        
        UIView *innerbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 120)];
        innerbackgroundView.center = self.center;
        innerbackgroundView.backgroundColor = [UIColor whiteColor];
        innerbackgroundView.layer.cornerRadius = 5;
        innerbackgroundView.layer.masksToBounds = YES;
        
        [self addSubview:innerbackgroundView];
        [self addSubview:self.plusButton];
        [self addSubview:self.minusButton];
        [self addSubview:self.acceptButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)setUnitCount:(NSUInteger)unitCount
{
    _unitCount = unitCount;
    [self.textField setText:[NSString stringWithFormat:@"%d", unitCount]];
}

- (void)plusClicked
{
    self.unitCount = MIN(self.maxCount, self.unitCount+1);
}

- (void)minusClicked
{
    self.unitCount = MAX(1, self.unitCount-1);
}

@end

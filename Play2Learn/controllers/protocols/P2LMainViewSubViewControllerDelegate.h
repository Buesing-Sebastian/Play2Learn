//
//  P2LMainViewSubViewControllerDelegate.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SubViewDirection {

    SubViewDirectionRightToLeft,
    SubViewDirectionLeftToRight,
    SubViewDirectionBottomToTop,
    SubViewDirectionTopToBottom

} SubViewDirection;

@protocol P2LMainViewSubViewControllerDelegate <NSObject>

@required

- (void)presentViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction;
- (void)dismissViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction;

@end

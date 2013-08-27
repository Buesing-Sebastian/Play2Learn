//
//  P2LInquiryViewControllerDelegate.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 01.07.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Inquiry.h"

@protocol P2LInquiryViewControllerDelegate <NSObject>

@required

- (void)answeredQuestion:(Question *)question withCorrectness:(float)correctness;

- (void)didFinishInquiry:(Inquiry *)inquiry withCorrectness:(CGFloat)correctness;

@end

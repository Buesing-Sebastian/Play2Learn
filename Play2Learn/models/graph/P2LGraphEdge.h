//
//  P2LGraphEdge.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P2LGraphEdge : NSObject

@property (nonatomic, assign, readonly) CGPoint startPoint;
@property (nonatomic, assign, readonly) CGPoint endPoint;

- (id)initWithStart:(CGPoint)startPoint andEnd:(CGPoint)endPoint;

@end

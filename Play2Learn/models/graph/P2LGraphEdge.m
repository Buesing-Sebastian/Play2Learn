//
//  P2LGraphEdge.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphEdge.h"

@implementation P2LGraphEdge

- (id)initWithStart:(CGPoint)startPoint andEnd:(CGPoint)endPoint
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"Edge from (%f:%f) to (%f:%f)", _startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y];
}

@end

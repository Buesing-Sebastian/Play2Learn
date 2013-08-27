//
//  P2LGraphPath.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2LGraphEdge.h"

@interface P2LGraphPath : NSObject

#pragma mark - initializers

- (id)initWithEdge:(P2LGraphEdge *)startEdge;
// edges will be connected as ordered in array
- (id)initWithEdges:(NSArray *)edges;

- (id)initWithPoints:(NSArray *)points;

#pragma mark - convenience getters

- (CGPoint)startPoint;
- (CGPoint)endPoint;

- (P2LGraphEdge *)startEdge;
- (P2LGraphEdge *)endEdge;

- (NSArray *)edges;
- (NSArray *)allPoints;

- (CGPoint)midPoint;
- (CGRect)bounds;
- (CGSize)boundsSize;

#pragma mark - manipulators

- (void)addEdge:(P2LGraphEdge *)newEdge;
- (void)addEdgeToEndPoint:(CGPoint)endPoint;

- (void)closePath;
- (void)appendPath:(P2LGraphPath *)path;

- (void)reversePoints;
- (void)movePointsWithXOffset:(CGFloat)xOffset andYOffset:(CGFloat)yOffset;

#pragma mark - convenience methods

- (BOOL)isClosed;
- (BOOL)containsPoint:(CGPoint)somePoint;
- (BOOL)containsEdge:(P2LGraphEdge *)someEdge;
- (BOOL)isInsidePoint:(CGPoint)somePoint;
- (BOOL)isAdjacentToPath:(P2LGraphPath *)somePath;
- (BOOL)edge:(P2LGraphEdge *)edgeA isConnectedToEdge:(P2LGraphEdge *)edgeB;

- (NSUInteger)indexOfEdge:(P2LGraphEdge *)someEdge ignoringDirection:(BOOL)ignoreDirection;

- (CGPoint)pointBeforePoint:(CGPoint)somePoint;
- (CGPoint)pointAfterPoint:(CGPoint)somePoint;
- (CGPoint)pointClosestToPoint:(CGPoint)somePoint;

- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB closestToPointC:(CGPoint)pointC;
- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB;
- (P2LGraphPath *)shortestPathFrom:(CGPoint)somePoint toPointInsidePath:(P2LGraphPath *)adjacentPath;

- (P2LGraphPath *)graphByJoiningWithAdjacentGraph:(P2LGraphPath *)secondGraph;

+ (int)numPointsOfPath:(P2LGraphPath *)path belowGradientWithSlope:(CGFloat)slope andOrigin:(CGPoint)origin;

@end

//
//  P2LGraphPath.h
//  Play2Learn
//
// This class represents the model of an area inside the conquer mode.
// It contains a number of edges which should all be connected to
// another.
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2LPathEdge.h"

@interface P2LGraphPath : NSObject

#pragma mark - initializers

// default initializer
- (id)initWithEdge:(P2LPathEdge *)startEdge;
// initializer with edges that will be connected as ordered in array
- (id)initWithEdges:(NSArray *)edges;
// initializer with array of points that will be converted into edges
- (id)initWithPoints:(NSArray *)points;

#pragma mark - convenience getters

// The startPoint is the startPoint of the first edge
- (CGPoint)startPoint;
// The endPoint is the endPoint of the last edge
- (CGPoint)endPoint;

// first edges added
- (P2LPathEdge *)startEdge;
// last edge added
- (P2LPathEdge *)endEdge;

// returns all edges
- (NSArray *)edges;
// returns all of the points contained inside the edges
// (does not contain any points twice)
- (NSArray *)allPoints;

// calculates the centroid (http://en.wikipedia.org/wiki/Centroid) for
// the graph.
- (CGPoint)centroid;
// calculate the midPoint of the path. The midPoint is the centroid for
// the bounds rectangle
- (CGPoint)midPoint;
// returns the smallest rectangle, that contains all points.
- (CGRect)bounds;
// returns the size of the smallest rectangle, that contains all points.
- (CGSize)boundsSize;

#pragma mark - manipulators

// adds an edge to the graph which's startPoint should be the endPoint
// of the current endEdge.
- (void)addEdge:(P2LPathEdge *)newEdge;
// adds a new edge from the current endPoint to the given point
- (void)addEdgeToEndPoint:(CGPoint)endPoint;

// closes the path by adding an edge from the current endPoint to the startPoint
- (void)closePath;
// adds the edges of another path to the current path
- (void)appendPath:(P2LGraphPath *)path;

// reverses the direction of all edges
- (void)reversePoints;
// moves the x,y values of all points of all edges by given offsets
- (void)movePointsWithXOffset:(CGFloat)xOffset andYOffset:(CGFloat)yOffset;

#pragma mark - convenience methods
// checks if the path is closed. It is closed if the startPoint and endPoint are equal.
- (BOOL)isClosed;
// checks wether a given point is a startPoint or endPoint of an edge
- (BOOL)containsPoint:(CGPoint)somePoint;
// checks if and edges is contained inside the path. (The matching edge can have a different direction).
- (BOOL)containsEdge:(P2LPathEdge *)someEdge;
// tests (if the path is closed) for a given point wether or not that point is inside the path.
// (Used to determine if the represented area has been selected).
- (BOOL)isInsidePoint:(CGPoint)somePoint;
// tests if this path has an equal edge of another path.
- (BOOL)isAdjacentToPath:(P2LGraphPath *)somePath;
// returns the index of a given edge inside the internal collection of edges
- (NSUInteger)indexOfEdge:(P2LPathEdge *)someEdge ignoringDirection:(BOOL)ignoreDirection;

// returns the point that comes before somePoint inside the connected directed graph
- (CGPoint)pointBeforePoint:(CGPoint)somePoint;
// returns the point that comes after somePoint inside the connected directed graph
- (CGPoint)pointAfterPoint:(CGPoint)somePoint;
// returns the point of [self allPoints] that is closed to somePoint
- (CGPoint)pointClosestToPoint:(CGPoint)somePoint;

// searches for 2 points (A,B) of this path the subpath that is closest to a point C not contained in this
// path.
- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB closestToPointC:(CGPoint)pointC;
// returns the subpath form one point of this GraphPath to another point of this GraphPath
- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB;
// for a given point of this path returns the shortest path to a point that is also in adjacentPath, which should
// should have at least one shared edges with this graph
- (P2LGraphPath *)shortestPathFrom:(CGPoint)somePoint toPointInsidePath:(P2LGraphPath *)adjacentPath;
// joins this graph with an adjacent graph
- (P2LGraphPath *)graphByJoiningWithAdjacentGraph:(P2LGraphPath *)secondGraph;

// returns for a given path the number of its points whose coordinates are below
// a gradient described by a slope and an origin point.
+ (int)numPointsOfPath:(P2LGraphPath *)path belowGradientWithSlope:(CGFloat)slope andOrigin:(CGPoint)origin;

@end

//
//  P2LGraphPathTests.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 15.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphPathTests.h"
#import "P2LGraphPath.h"

@implementation P2LGraphPathTests

- (void)testBoundsSize
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(195, 20)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(190, 170)];
    [path addEdgeToEndPoint:CGPointMake(30, 190)];
    [path closePath];
    
    CGSize bounds = [path boundsSize];
    
    STAssertEquals(bounds.width, 185.0f, @"Width of bounds size is 185");
    STAssertEquals(bounds.height, 180.0f, @"Height of bounds size is 180");
}

- (void)testContainsPoint
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(195, 20)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(190, 170)];
    [path addEdgeToEndPoint:CGPointMake(30, 190)];
    [path closePath];
    
    STAssertTrue([path containsPoint:CGPointMake(10, 10)], @"path should contain 10x10");
    STAssertTrue([path containsPoint:CGPointMake(195, 20)], @"path should contain 195x20");
    STAssertTrue([path containsPoint:CGPointMake(190, 170)], @"path should contain 190x170");
    STAssertTrue([path containsPoint:CGPointMake(30, 190)], @"path should contain 30x190");
    
    STAssertFalse([path containsPoint:CGPointMake(10, 20)], @"path should not contain 10x20");
}

- (void)testIsInsidePoint
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(60, 10)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(60, 40)];
    [path addEdgeToEndPoint:CGPointMake(50, 40)];
    [path addEdgeToEndPoint:CGPointMake(50, 20)];
    [path addEdgeToEndPoint:CGPointMake(20, 20)];
    [path addEdgeToEndPoint:CGPointMake(20, 40)];
    [path addEdgeToEndPoint:CGPointMake(30, 40)];
    [path addEdgeToEndPoint:CGPointMake(30, 30)];
    [path addEdgeToEndPoint:CGPointMake(40, 30)];
    [path addEdgeToEndPoint:CGPointMake(40, 60)];
    [path addEdgeToEndPoint:CGPointMake(10, 60)];
    [path closePath];
    
    STAssertTrue([path isInsidePoint:CGPointMake(10, 10)], @"10x10 inside rect");
    STAssertTrue([path isInsidePoint:CGPointMake(15, 15)], @"15x15 inside rect");
    STAssertTrue([path isInsidePoint:CGPointMake(35, 35)], @"35x35 inside rect");
    
    STAssertFalse([path isInsidePoint:CGPointMake(25, 35)], @"25x35 not inside rect");
    STAssertFalse([path isInsidePoint:CGPointMake(25, 35)], @"25x35 not inside rect");
}

- (void)testGraphByJoiningWithAdjacentGraph
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(195, 20)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(170, 100)];
    [path addEdgeToEndPoint:CGPointMake(190, 170)];
    [path addEdgeToEndPoint:CGPointMake(30, 190)];
    [path closePath];
    
    edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(195, 20) andEnd:CGPointMake(300, 30)];
    
    P2LGraphPath *newPath = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [newPath addEdgeToEndPoint:CGPointMake(250, 120)];
    [newPath addEdgeToEndPoint:CGPointMake(190, 170)];
    [newPath addEdgeToEndPoint:CGPointMake(170, 100)];
    [newPath closePath];
    
    path = [path graphByJoiningWithAdjacentGraph:newPath];
    
    STAssertTrue([path containsPoint:CGPointMake(10, 10)], @"path should contain 10x10");
    STAssertTrue([path containsPoint:CGPointMake(195, 20)], @"path should contain 195x20");
    STAssertTrue([path containsPoint:CGPointMake(190, 170)], @"path should contain 190x170");
    STAssertTrue([path containsPoint:CGPointMake(30, 190)], @"path should contain 30x190");
    STAssertTrue([path containsPoint:CGPointMake(250, 120)], @"path should contain 250x120");
    STAssertTrue([path containsPoint:CGPointMake(300, 30)], @"path should contain 300x30");
    
    STAssertFalse([path containsPoint:CGPointMake(170, 100)], @"path should not contain 170x100");
}

- (void)testClosestPointToPoint
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(10, 10) andEnd:CGPointMake(195, 20)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(190, 170)];
    [path addEdgeToEndPoint:CGPointMake(30, 190)];
    [path closePath];
    
    CGPoint closestPoint = [path pointClosestToPoint:CGPointMake(20, 20)];
    STAssertTrue(CGPointEqualToPoint(closestPoint, CGPointMake(10, 10)), @"closest point should be 10x10");
    
    closestPoint = [path pointClosestToPoint:CGPointMake(160, 50)];
    STAssertTrue(CGPointEqualToPoint(closestPoint, CGPointMake(195, 20)), @"closest point should be 195x20");
    
    closestPoint = [path pointClosestToPoint:CGPointMake(50, 50)];
    STAssertTrue(CGPointEqualToPoint(closestPoint, CGPointMake(10, 10)), @"closest point should be 10x10");
}

- (void)testPathFromPointAtoPointBclosestToPointC
{
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:CGPointMake(200, 600) andEnd:CGPointMake(300, 300)];
    
    P2LGraphPath *path = [[P2LGraphPath alloc] initWithEdge:edge];
    
    [path addEdgeToEndPoint:CGPointMake(600, 400)];
    [path addEdgeToEndPoint:CGPointMake(450, 420)];
    [path closePath];
    
    CGPoint pointA = CGPointMake(200, 600);
    CGPoint pointB = CGPointMake(600, 400);
    CGPoint pointC = CGPointMake(150, 550);
    
    P2LGraphPath *connectingPath = [path pathFromPointA:pointA toPointB:pointB closestToPointC:pointC];
    
    STAssertTrue([connectingPath containsPoint:CGPointMake(200, 600)], @"connectingPath should contain 10x10");
    STAssertTrue([connectingPath containsPoint:CGPointMake(300, 300)], @"connectingPath should contain 195x20");
    STAssertTrue([connectingPath containsPoint:CGPointMake(600, 400)], @"connectingPath should contain 190x170");
    
    STAssertFalse([connectingPath containsPoint:CGPointMake(450, 420)], @"connectingPath should not contain 170x100");
    
    pointC = CGPointMake(190, 680);
    connectingPath = [path pathFromPointA:pointA toPointB:pointB closestToPointC:pointC];
    
    STAssertTrue([connectingPath containsPoint:CGPointMake(200, 600)], @"connectingPath should contain 10x10");
    STAssertTrue([connectingPath containsPoint:CGPointMake(450, 420)], @"connectingPath should contain 195x20");
    STAssertTrue([connectingPath containsPoint:CGPointMake(600, 400)], @"connectingPath should contain 190x170");
    
    STAssertFalse([connectingPath containsPoint:CGPointMake(300, 300)], @"connectingPath should not contain 170x100");
}

@end

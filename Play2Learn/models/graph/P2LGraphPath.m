//
//  P2LGraphPath.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphPath.h"

@interface P2LGraphPath ()

@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *allPoints;
@property (nonatomic, assign) int failSafeCounter;

@end

@implementation P2LGraphPath

#pragma mark - initializers

- (id)initWithEdge:(P2LGraphEdge *)startEdge
{
    self = [super init];
    if (self)
    {
        //
        _edges = [NSMutableArray new];
        _allPoints = [NSMutableArray new];
        [self addEdge:startEdge];
    }
    return self;
    
}
// edges will be connected as ordered in array
- (id)initWithEdges:(NSArray *)edges
{
    self = [super init];
    if (self)
    {
        //
        _edges = [NSMutableArray new];
        _allPoints = [NSMutableArray new];
        
        for (P2LGraphEdge *edge in edges)
        {
            [self addEdge:edge];
        }
    }
    return self;
    
}

- (id)initWithPoints:(NSArray *)points
{
    self = [super init];
    if (self)
    {
        //
        _edges = [NSMutableArray new];
        _allPoints = [points mutableCopy];
        
        [self redoEdgesUsingPoints];
    }
    return self;
}

#pragma mark - convenience getters

- (CGPoint)startPoint
{
    return [[self startEdge] startPoint];
}

- (CGPoint)endPoint
{
    return [[self endEdge] endPoint];
}

- (P2LGraphEdge *)startEdge
{
    return (P2LGraphEdge *)[_edges objectAtIndex:0];
}

- (P2LGraphEdge *)endEdge
{
    return (P2LGraphEdge *)[_edges objectAtIndex:MAX(0, [_edges count] - 1)];
}

- (NSArray *)edges
{
    return [_edges copy];
}


- (NSArray *)allPoints
{
    if (_allPoints)
    {
        return [_allPoints copy];
    }
    
    NSMutableArray *vertices = [NSMutableArray new];
    
    for (int i = 0; i < [_edges count]; i++)
    {
        P2LGraphEdge *edge = [_edges objectAtIndex:i];
        [vertices addObject:[NSValue valueWithCGPoint:edge.startPoint]];
    }
    P2LGraphEdge *edge = [_edges objectAtIndex:MAX(0, [_edges count]-1)];
    [vertices addObject:[NSValue valueWithCGPoint:edge.endPoint]];
    
    _allPoints = vertices;
    
    return [vertices copy];
}


- (CGPoint)midPoint
{
    CGFloat minX = MAXFLOAT, maxX = 0, minY = MAXFLOAT, maxY = 0;
    
    for (NSValue *value in [self allPoints])
    {
        CGPoint point = [value CGPointValue];
        
        if (point.x < minX)
        {
            minX = point.x;
        }
        if (point.x > maxX)
        {
            maxX = point.x;
        }
        if (point.y < minY)
        {
            minY = point.y;
        }
        if (point.y > maxY)
        {
            maxY = point.y;
        }
    }
    
    return CGPointMake(minX + ((maxX - minX) / 2.0f), minY + ((maxY - minY) / 2.0f));
}

- (CGSize)boundsSize
{
    CGFloat minX = MAXFLOAT, maxX = 0, minY = MAXFLOAT, maxY = 0;
    
    for (NSValue *value in [self allPoints])
    {
        CGPoint point = [value CGPointValue];
        
        if (point.x < minX)
        {
            minX = point.x;
        }
        if (point.x > maxX)
        {
            maxX = point.x;
        }
        if (point.y < minY)
        {
            minY = point.y;
        }
        if (point.y > maxY)
        {
            maxY = point.y;
        }
    }
    
    return CGSizeMake(maxX - minX, maxY - minY);
}

- (CGRect)bounds
{
    CGFloat minX = MAXFLOAT, maxX = 0, minY = MAXFLOAT, maxY = 0;
    
    for (NSValue *value in [self allPoints])
    {
        CGPoint point = [value CGPointValue];
        
        if (point.x < minX)
        {
            minX = point.x;
        }
        if (point.x > maxX)
        {
            maxX = point.x;
        }
        if (point.y < minY)
        {
            minY = point.y;
        }
        if (point.y > maxY)
        {
            maxY = point.y;
        }
    }
    int border = 4;
    
    return CGRectMake(minX - border, minY - border, (maxX - minX) + 2*border, (maxY - minY) + 2*border);
}

#pragma mark - manipulators

- (void)addEdge:(P2LGraphEdge *)newEdge
{
    if ([_edges count] && !CGPointEqualToPoint([self endPoint], [newEdge startPoint]))
    {
        [NSException raise:NSInternalInconsistencyException format:@"Can only add Edges whose startPoint ist the same as the path' endPoint"];
    }
    else
    {
        if ([self containsPoint:[newEdge endPoint]] && !CGPointEqualToPoint([self startPoint], [newEdge endPoint]))
        {
            int debug = 0;
        }
        [_edges addObject:newEdge];
        
        if (![self isClosed])
        {
            if ([_allPoints count])
            {
                [_allPoints addObject:[NSValue valueWithCGPoint:[newEdge endPoint]]];
            }
            else
            {
                [_allPoints addObject:[NSValue valueWithCGPoint:[newEdge startPoint]]];
                [_allPoints addObject:[NSValue valueWithCGPoint:[newEdge endPoint]]];
            }
        }
    }
}

- (void)addEdgeToEndPoint:(CGPoint)endPoint
{
    P2LGraphEdge *edge = [[P2LGraphEdge alloc] initWithStart:[self endPoint] andEnd:endPoint];
    
    [self addEdge:edge];
}

- (void)closePath
{
    if ([_edges count] <= 1)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Can only close path with >= 2 edges"];
    }
    else
    {
        if (!CGPointEqualToPoint([self startPoint], [self endPoint]))
        {
            [self addEdgeToEndPoint:[self startPoint]];
        }
    }
}

- (void)appendPath:(P2LGraphPath *)path
{
    if (path == nil)
    {
        return;
    }
    if (!CGPointEqualToPoint([self endPoint], [path startPoint]))
    {
        [self addEdgeToEndPoint:[path startPoint]];
    }
    
    NSMutableArray *newEdges = [[path edges] mutableCopy];
    
    if (CGPointEqualToPoint([self endPoint], [path startPoint]) )
    {
        //[newEdges removeObjectAtIndex:0];
    }
    
    NSArray *before = [[self edges] copy];
    
    for (P2LGraphEdge *edge in newEdges)
    {
        if ([self containsPoint:[edge endPoint]])
        {
            [NSException raise:NSInvalidArgumentException format:@"Adding this path destroys the structural definition of a path. There cannot be multiple edges to the same point"];
        }
        [self addEdge:edge];
    }
}

- (void)reversePoints
{
    NSArray *currentPoints = [self allPoints];
    NSMutableArray *newPoints = [NSMutableArray new];
    
    for (int i = [currentPoints count] - 1; i >= 0; i--)
    {
        [newPoints addObject:[currentPoints objectAtIndex:i]];
    }
    _allPoints = newPoints;
    
    [self redoEdgesUsingPoints];
}

- (void)movePointsWithXOffset:(CGFloat)xOffset andYOffset:(CGFloat)yOffset
{
    NSArray *currentPoints = [self allPoints];
    NSMutableArray *newPoints = [NSMutableArray new];
    
    for (int i = 0; i < [currentPoints count]; i++)
    {
        NSValue *thisValue = [currentPoints objectAtIndex:i];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        thisPoint.x += xOffset;
        thisPoint.y += yOffset;
        
        [newPoints addObject:[NSValue valueWithCGPoint:thisPoint]];
    }
    
    _allPoints = newPoints;
    
    [self redoEdgesUsingPoints];
}

#pragma mark - convenience methods

- (BOOL)isClosed
{
    if ([_edges count])
    {
        if (CGPointEqualToPoint([self startPoint], [self endPoint]))
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsPoint:(CGPoint)somePoint
{
    for (NSValue *value in [self allPoints])
    {
        CGPoint point = [value CGPointValue];
        
        if (CGPointEqualToPoint(somePoint, point))
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsEdge:(P2LGraphEdge *)someEdge
{
    if (someEdge == nil)
    {
        return NO;
    }
    P2LGraphEdge *reversedEdge = [[P2LGraphEdge alloc] initWithStart:[someEdge endPoint] andEnd:[someEdge startPoint]];
    
    for (P2LGraphEdge *edge in _edges)
    {
        if (CGPointEqualToPoint(edge.startPoint, someEdge.startPoint) &&
            CGPointEqualToPoint(edge.endPoint, someEdge.endPoint))
        {
            return YES;
        }
        if (CGPointEqualToPoint(edge.startPoint, reversedEdge.startPoint) &&
            CGPointEqualToPoint(edge.endPoint, reversedEdge.endPoint))
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isInsidePoint:(CGPoint)somePoint
{
    // method: http://de.wikipedia.org/wiki/Punkt-in-Polygon-Test_nach_Jordan
    
    if ([self containsPoint:somePoint])
    {
        return YES;
    }
    
    float slope = 2;
    int edgesCrossed = 0;
    
    // count how many edges we cross
    for (P2LGraphEdge *edge in _edges)
    {
        BOOL startAbove = [self isPoint:[self pointByConvertingPoint:[edge startPoint] toOrigion:somePoint] aboveGradientWithSlope:slope];
        BOOL endAbove = [self isPoint:[self pointByConvertingPoint:[edge endPoint] toOrigion:somePoint] aboveGradientWithSlope:slope];
        
        if (startAbove != endAbove)
        {
            // create gradient for edge
            CGPoint pointS;
            CGPoint pointR;
            
            if ([edge startPoint].y > [edge startPoint].y)
            {
                pointS = [edge startPoint];
                pointR = [edge endPoint];
            }
            else
            {
                pointS = [edge endPoint];
                pointR = [edge startPoint];
            }
            float edgeSlope = (pointS.y - pointR.y) / (pointR.x - pointS.x);
            // use pointR to calculate yOffset (y = edgeSlope * x + yOffsetEdge)
            float yOffsetEdge = (-pointR.y) - (edgeSlope * pointR.x);
            // additionally we need the yOffset for somePoint
            float yOffset = (-somePoint.y) - (slope * somePoint.x);
            // calculate x coordinate of intersection
            float intersectionX = (yOffsetEdge - yOffset) / (slope - edgeSlope);
            
            // if x >= somePoint.x then this point we count the
            // crossing of the edge. Otherwise we dont, because it
            // is in the wrong direction.
            if (intersectionX >= somePoint.x)
            {
                edgesCrossed++;
            }
        }
    }
    
    return ((edgesCrossed % 2) == 1);
}

- (BOOL)isAdjacentToPath:(P2LGraphPath *)somePath
{
    NSArray *myPoints = [self allPoints];
    NSArray *somePoints = [somePath allPoints];
    
    // TODO: not the fastest way to check this.
    for (int i = 0; i < somePoints.count; i++)
    {
        for (int j = 0; j < myPoints.count; j++)
        {
            NSValue *myValue = [myPoints objectAtIndex:j];
            NSValue *someValue = [somePoints objectAtIndex:i];
            
            if (CGPointEqualToPoint(myValue.CGPointValue, someValue.CGPointValue))
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)edge:(P2LGraphEdge *)edgeA isConnectedToEdge:(P2LGraphEdge *)edgeB
{
    return (CGPointEqualToPoint([edgeA endPoint], [edgeB startPoint])
            || CGPointEqualToPoint([edgeB startPoint], [edgeA endPoint]));
}

- (NSUInteger)indexOfEdge:(P2LGraphEdge *)someEdge ignoringDirection:(BOOL)ignoreDirection
{
    if (someEdge == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"edge not inside path"];
    }
    P2LGraphEdge *reversedEdge = [[P2LGraphEdge alloc] initWithStart:[someEdge endPoint] andEnd:[someEdge startPoint]];
    
    for (int i = 0; i < _edges.count; i++)
    {
        P2LGraphEdge *edge  = [_edges objectAtIndex:i];
        
        if (CGPointEqualToPoint(edge.startPoint, someEdge.startPoint) &&
            CGPointEqualToPoint(edge.endPoint, someEdge.endPoint))
        {
            return i;
        }
        if (ignoreDirection &&
            CGPointEqualToPoint(edge.startPoint, reversedEdge.startPoint) &&
            CGPointEqualToPoint(edge.endPoint, reversedEdge.endPoint))
        {
            return i;
        }
    }
    
    [NSException raise:NSInvalidArgumentException format:@"edge not inside path"];
    
    return 0;
}

- (CGPoint)pointBeforePoint:(CGPoint)somePoint
{
    NSArray *allPoints = [self allPoints];
    
    int pointIndex = [self indexOfPoint:somePoint];
    
    if (pointIndex == -1)
    {
        [NSException raise:NSInvalidArgumentException format:@"Point not contained in path!"];
    }
    
    if (pointIndex == 0)
    {
        NSValue *thisValue = [allPoints objectAtIndex:[allPoints count] - 1];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        return thisPoint;
    }
    else
    {
        NSValue *thisValue = [allPoints objectAtIndex:pointIndex - 1];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        return thisPoint;
    }
}

- (CGPoint)pointAfterPoint:(CGPoint)somePoint
{
    NSArray *allPoints = [self allPoints];
    
    int pointIndex = [self indexOfPoint:somePoint];
    
    if (pointIndex == -1)
    {
        [NSException raise:NSInvalidArgumentException format:@"Point not contained in path!"];
    }

    if (pointIndex == [allPoints count] - 1)
    {
        NSValue *thisValue = [allPoints objectAtIndex:0];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        return thisPoint;
    }
    else
    {
        NSValue *thisValue = [allPoints objectAtIndex:pointIndex + 1];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        return thisPoint;
    }
}

- (CGPoint)pointClosestToPoint:(CGPoint)somePoint
{
    NSArray *allPoints = [self allPoints];
    
    // create some really far away point to start with
    CGPoint closestPoint = CGPointMake(MAXFLOAT / 2.0f, MAXFLOAT / 2.0f);
    CGFloat minDistance = MAXFLOAT / 2.0f;
    
    for (int i = 0; i < [allPoints count]; i++)
    {
        NSValue *thisValue = [allPoints objectAtIndex:i];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        // calculate euclidean distance
        CGFloat thisDistance = sqrtf(powf((somePoint.x - thisPoint.x), 2.0f) + powf((somePoint.y - thisPoint.y), 2.0f));
        
        if (thisDistance < minDistance)
        {
            minDistance = thisDistance;
            closestPoint = thisPoint;
        }
    }
    return closestPoint;
}

- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB closestToPointC:(CGPoint)pointC
{
    // we calculate the slope for the gradient through
    // pointA and pointB (called A-B-Gradient) to get y = m * x. 
    CGFloat slope = [self slopeForGradientConnectingPointA:pointA toPointB:pointB];
    
    // get pointC' in relation to pointA
    CGPoint pointCInCorrolationToA = [self pointByConvertingPoint:pointC toOrigion:pointA];
    // and check if it is above the gradient.
    BOOL above = [self isPoint:pointCInCorrolationToA aboveGradientWithSlope:slope];
    
    /*
     * ALGORITHM:
     *
     * We first simple grab the two possible path from A to B, which are going
     * clockwise (right) and counterclockwise (left).
     * Then we count how many of the points making up the two paths are below
     * the A-B-Gradient. If one number is lower than the other we simple take 
     * that candidate.
     * Otherwise we have to do some more math. We look at the two possible next
     * points from A on the rightPath (rightPoint) and leftPath (leftPoint) 
     * respectively. We one extra gradient from A to leftPoint (AL-Gradient). 
     * Now we have to look at two case:
     *      CASE 1: pointC is above A-B-Gradient:
     *
     *      Here we check if rightPoint is above AL-Gradient. If that is the case
     *      than we return the rightPath.
     *
     *      CASE 2: pointC is below the A-B Gradient:
     *
     *      Now we check again if is above AL-Gradient. If that is the case
     *      than in this case we retun leftPath.
     */
    
    // create clockwise path
    P2LGraphPath *rightPath = [self pathFromPointA:pointA toPointB:pointB];

    // create counter clockwise path
    P2LGraphPath *clone = [[P2LGraphPath alloc] initWithEdges:_edges];
    [clone reversePoints];
    
    P2LGraphPath *leftPath = [clone pathFromPointA:pointA toPointB:pointB];
    
    // count points below for each path.
    int rightCount = [P2LGraphPath numPointsOfPath:rightPath belowGradientWithSlope:slope andOrigin:pointA];
    int leftCount = [P2LGraphPath numPointsOfPath:leftPath belowGradientWithSlope:slope andOrigin:pointA];
    
    // check for the easy case
    if (above)
    {
        if (rightCount > leftCount)
        {
            return leftPath;
        }
        else if (leftCount > rightCount)
        {
            return rightPath;
        }
    }
    else
    {
        if (rightCount < leftCount)
        {
            return leftPath;
        }
        else if (leftCount < rightCount)
        {
            return rightPath;
        }
    }
    
    // rightCount == leftCount. Both paths are above the A-B-Gradient.
    CGFloat newSlope = [self slopeForGradientConnectingPointA:pointA toPointB:[leftPath pointAfterPoint:pointA]];
    
    if (above)
    {
        CGPoint rightPoint = [self pointByConvertingPoint:[rightPath pointAfterPoint:pointA] toOrigion:pointA];
        
        if ([self isPoint:rightPoint aboveGradientWithSlope:newSlope])
        {
            return rightPath;
        }
        else
        {
            return leftPath;
        }
    }
    else
    {
        CGPoint rightPoint = [self pointByConvertingPoint:[rightPath pointAfterPoint:pointA] toOrigion:pointA];
        
        if ([self isPoint:rightPoint aboveGradientWithSlope:newSlope])
        {
            return leftPath;
        }
        else
        {
            return rightPath;
        }
    }
}

- (P2LGraphPath *)pathFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    if (CGPointEqualToPoint(pointA, pointB))
    {
        //[NSException raise:NSInvalidArgumentException format:@"cannot create path with start and end being the same point"];
        return [[P2LGraphPath alloc] initWithEdge:[[P2LGraphEdge alloc] initWithStart:pointA andEnd:pointB]];
    }
    
    P2LGraphPath *leftPath;
    
    CGPoint currentPoint = pointA;
    CGPoint endPoint = pointB;
    CGPoint startPoint = CGPointMake(MAXFLOAT, 0.0f);
    
    while (!CGPointEqualToPoint(currentPoint, endPoint))
    {
        if (leftPath)
        {
            [leftPath addEdgeToEndPoint:currentPoint];
        }
        else
        {
            if (CGPointEqualToPoint(startPoint, CGPointMake(MAXFLOAT, 0.0f)))
            {
                startPoint = currentPoint;
            }
            else
            {
                leftPath = [[P2LGraphPath alloc] initWithEdge:[[P2LGraphEdge alloc] initWithStart:startPoint andEnd:currentPoint]];
            }
        }
        currentPoint = [self pointAfterPoint:currentPoint];
    }
    // extra handling for path with only one egde
    if (leftPath == nil && !CGPointEqualToPoint(startPoint, CGPointMake(MAXFLOAT, 0.0f)) &&
        CGPointEqualToPoint(currentPoint, pointB))
    {
        return leftPath = [[P2LGraphPath alloc] initWithEdge:[[P2LGraphEdge alloc] initWithStart:startPoint andEnd:currentPoint]];
    }
    
    [leftPath addEdgeToEndPoint:currentPoint];
    
    return leftPath;
}

- (P2LGraphPath *)shortestPathFrom:(CGPoint)somePoint toPointInsidePath:(P2LGraphPath *)adjacentPath
{
    // TODO: check if adjacentPath is really adjacent
    if (![self isAdjacentToPath:adjacentPath])
    {
        [NSException raise:NSInvalidArgumentException format:@"path is not adjacent!"];
    }
    
    if (![self containsPoint:somePoint])
    {
        [NSException raise:NSInvalidArgumentException format:@"path does not contain somePoint"];
    }
    
    P2LGraphEdge *leftEdge = [[P2LGraphEdge alloc] initWithStart:somePoint andEnd:[self pointBeforePoint:somePoint]];
    P2LGraphPath *leftPath = [[P2LGraphPath alloc] initWithEdge:leftEdge];
    
    P2LGraphEdge *rightEdge = [[P2LGraphEdge alloc] initWithStart:somePoint andEnd:[self pointAfterPoint:somePoint]];
    P2LGraphPath *rightPath = [[P2LGraphPath alloc] initWithEdge:rightEdge];
    
    self.failSafeCounter = 0;
    
    return [self shortestPathBetweenLeftPath:leftPath andRightPath:rightPath toPointInsidePath:adjacentPath];
}

- (BOOL)isPoint:(CGPoint)somePoint aboveGradientWithSlope:(CGFloat)slope
{
    CGFloat mTimesX = slope * somePoint.x;
    
    if (somePoint.y >= mTimesX)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (P2LGraphPath *)graphByJoiningWithAdjacentGraph:(P2LGraphPath *)secondGraph
{
    if (![self isAdjacentToPath:secondGraph])
    {
        [NSException raise:NSInvalidArgumentException format:@"graph not adjacent!"];
    }
    P2LGraphPath *newPath;
    
    if (![self isClosed] || ![secondGraph isClosed])
    {
        [NSException raise:NSInvalidArgumentException format:@"can only join closed graphs!"];
    }

    NSMutableArray *myEdges = [[self edges] mutableCopy];
    NSMutableArray *hisEgdes = [[secondGraph edges] mutableCopy];
    
    NSMutableIndexSet *mySet = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *hisSet = [[NSMutableIndexSet alloc] init];
    
    // New approach. We join by delete same shared edges in both
    // graphs and the we connect them at the points they share,
    // which should leave one connected outer graph.
    
    for (int i = 0; i < [self edges].count; i++)
    {
        P2LGraphEdge *myEdge = [[self edges] objectAtIndex:i];
        // remember that containsEgdes does not care about
        // the direction of the edge, which is exactly what
        // is needed here.
        if ([secondGraph containsEdge:myEdge])
        {
            // save the idexes, so we can delete them all at once.
            [mySet addIndex:i];
            [hisSet addIndex:[secondGraph indexOfEdge:myEdge ignoringDirection:YES]];
        }
    }
    
    // make sure the edges are point in different directions
    // so dont have to deal with both cases while joining.
    P2LGraphEdge *myTest = [myEdges objectAtIndex:[mySet firstIndex]];
    P2LGraphEdge *hisTest = [hisEgdes objectAtIndex:[hisSet firstIndex]];
    
    if (CGPointEqualToPoint(myTest.startPoint, hisTest.startPoint))
    {
        // same direction! Lets swap
        [secondGraph reversePoints];
        hisEgdes = [[secondGraph edges] mutableCopy];
        // we have to redo one indexSet now
        int start = hisEgdes.count - 2 - [hisSet lastIndex];
        int end = hisEgdes.count - 2 - [hisSet firstIndex];
        
        hisSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(start, end-start+1)];
        
        if (start == -1)
        {
            [hisSet addIndex:hisEgdes.count-1];
        }
    }
    
    // now delete the edges we dont need anymore.
    [myEdges removeObjectsAtIndexes:mySet];
    [hisEgdes removeObjectsAtIndexes:hisSet];
    
    NSMutableArray *newEdges = [[NSMutableArray alloc] init];
    
    int currentIndex = 0;
    NSMutableArray *activeEdges = myEdges;
    NSMutableArray *inactiveEdges = hisEgdes;
    
    while (newEdges.count != (myEdges.count + hisEgdes.count))
    {
        // add the from the activeEdges the edge at the currentIndex.
        P2LGraphEdge *currentEdge = [activeEdges objectAtIndex:currentIndex];
        [newEdges addObject:currentEdge];
        
        // now look at how to go forth. Check the if the next edge
        // is connected to the next one.
        int nextIndex = currentIndex == activeEdges.count-1 ? 0 : currentIndex+1;
        P2LGraphEdge *nextEdge = [activeEdges objectAtIndex:nextIndex];
        
        if (CGPointEqualToPoint([nextEdge startPoint], [currentEdge endPoint]))
        {
            // if so, we continue grabbing edges from the currently active array.
            currentIndex = nextIndex;
            continue;
        }
        else
        {
            // otherwise we have to switch. For that we need the index of the
            // edge which has the same startPoint of the currentEdge's endPoint.
            NSMutableArray *temp;
            for (int j = 0; j < inactiveEdges.count; j++)
            {
                P2LGraphEdge *someEdge = [inactiveEdges objectAtIndex:j];
                
                if (CGPointEqualToPoint([someEdge startPoint], [currentEdge endPoint]))
                {
                    currentIndex = j;
                    // swap active inactive
                    temp = activeEdges;
                    activeEdges = inactiveEdges;
                    inactiveEdges = temp;
                    break;
                }
            }
            // if temp is nil, that we have not found the desired new edge, so sth should
            // have gon wrong. so we throw an exception
            if (temp == nil)
            {
                [NSException raise:NSInternalInconsistencyException format:@"Algorithm produced unexpected state!"];
            }
        }
    }
    
    newPath = [[P2LGraphPath alloc] initWithEdges:newEdges];
    
    for (NSValue *pointValue in [newPath allPoints])
    {
        int index = 0;
        CGPoint point = pointValue.CGPointValue;
        
        for (NSValue *somePointValue in [newPath allPoints])
        {
            CGPoint somePoint = somePointValue.CGPointValue;
            
            if (CGPointEqualToPoint(point, somePoint))
            {
                index++;
            }
        }
        
        if (index > 1)
        {
            [NSException raise:NSInternalInconsistencyException format:@"Algorithm produced unexpected state!"];
        }
    }
    
    return newPath;
}

//- (P2LGraphPath *)graphByJoiningWithAdjacentGraph:(P2LGraphPath *)secondGraph
//{
//    if (![self isAdjacentToPath:secondGraph])
//    {
//        [NSException raise:NSInvalidArgumentException format:@"graph not adjacent!"];
//    }
//    P2LGraphPath *newPath;
//    
//    if (![self isClosed] || ![secondGraph isClosed])
//    {
//        [NSException raise:NSInvalidArgumentException format:@"can only join closed graphs!"];
//    }
//
//    /*
//     * How to join 2 polygons:
//     * We start with startPoint of Polygon A. If this point is also in Polygon B then we look the next point.
//     * If that point is not in Polygon B, then we have reached the startPoint. Otherwise we go to the next
//     * point and start the procedure again. If startPoint of Polygon A is not inside B, then we also jumped to
//     * the next point. 
//     * After reaching our new startPoint we should be at one of the two outer points connecting Polygon A and B.
//     * We remeber that point and start looking at the next point of A. If not inside A and B, we add an edge
//     * from the startPoint to it into the graph and continue from that next point. If however the point is inside 
//     * both A and B, then we change our active Polygon to B and look at the point again this time looking at the 
//     * next point inside B respectively. 
//     * We repeat this procedure until we are at a point where the next point is our original start point and at that
//     * moment we can simply close the graph.
//     */
//    CGPoint startPoint = CGPointZero;
//    P2LGraphPath *activeGraph = self;
//    P2LGraphPath *inactiveGrap = secondGraph;
//    
//    CGPoint tempStart = [self startPoint];
//    // find start point
//    while ([secondGraph containsPoint:tempStart])
//    {
//        tempStart = [self pointAfterPoint:tempStart];
//    }
//    // set start point
//    startPoint = tempStart;
//    
//    // set intial loop values
//    CGPoint nextPoint = [self pointAfterPoint:startPoint];
//    CGPoint currentPoint = startPoint;
//    
//    // we keep a counter for swapping graphs. If we swap two times
//    // after another then we are stuck and cannot find a next point
//    // to add. In that case we change the direction of the inactive
//    // graph and reset the while loop.
//    int missCounter = 0;
//    
//    NSLog(@"\n\n START!!!! \n\n");
//    
//    // loop until we are back at start point
//    while (!CGPointEqualToPoint(startPoint, nextPoint))
//    {
//        NSLog(@"currentPoint: (%f,%f) - nextPoint: (%f, %f)", currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
//        // reverse inactive graph and reset loop
//        if (missCounter == 2)
//        {
//            NSLog(@"reverse!");
//            [inactiveGrap reversePoints];
//            newPath = nil;
//            
//            nextPoint = [self pointAfterPoint:startPoint];
//            currentPoint = startPoint;
//            
//            missCounter = 0;
//            continue;
//        }
//        // if the next point is inside the other graph
//        // we cannot add it and have to switch active graphs
//        if ([inactiveGrap containsPoint:nextPoint] && [inactiveGrap containsPoint:currentPoint])
//        {
//            NSLog(@"MISS (%d)! swapping", missCounter);
//            P2LGraphPath *temp = activeGraph;
//            activeGraph = inactiveGrap;
//            inactiveGrap = temp;
//            
//            nextPoint = [activeGraph pointAfterPoint:currentPoint];
//            
//            missCounter++;
//        }
//        else
//        {
//            missCounter = 0;
//            
//            if (newPath)
//            {
//                if ([newPath containsPoint:nextPoint])
//                {
//                    int kacke = 1;
//                }
//                [newPath addEdgeToEndPoint:nextPoint];
//            }
//            else
//            {
//                newPath = [[P2LGraphPath alloc] initWithEdge:[[P2LGraphEdge alloc] initWithStart:currentPoint andEnd:nextPoint]];
//            }
//            // set up for next loop
//            currentPoint = nextPoint;
//            nextPoint = [activeGraph pointAfterPoint:currentPoint];
//        }
//    }
//    // next point == start point, so we just close the path to get
//    // that edge
//    [newPath closePath];
//    
//    return newPath;
//}

+ (int)numPointsOfPath:(P2LGraphPath *)path belowGradientWithSlope:(CGFloat)slope andOrigin:(CGPoint)origin
{
    NSArray *allPoints = [path allPoints];
    
    int below = 0;
    
    for (int i = 0; i < [allPoints count]; i++)
    {
        NSValue *thisValue = [allPoints objectAtIndex:i];
        CGPoint thisPoint = [thisValue CGPointValue];
        thisPoint = [path pointByConvertingPoint:thisPoint toOrigion:origin];
        
        if (![path isPoint:thisPoint aboveGradientWithSlope:slope])
        {
            below++;
        }
    }
    
    return below;
}

#pragma mark - private methods

- (CGPoint)pointByConvertingPoint:(CGPoint)somePoint toOrigion:(CGPoint)originPoint
{
    CGFloat newX = somePoint.x - originPoint.x;
    CGFloat newY = originPoint.y - somePoint.y;
    
    return CGPointMake(newX, newY);
}

- (CGFloat)slopeForGradientConnectingPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    return (pointA.y - pointB.y) / (pointB.x - pointA.x);
}

- (void)redoEdgesUsingPoints
{
    BOOL closed = [self isClosed];
    
    _edges = [NSMutableArray new];
    
    NSValue *lastPoint = [_allPoints objectAtIndex:0];
    NSValue *nextPoint = [_allPoints objectAtIndex:1];
    
    int i;
    
    for (i = 1; i < [_allPoints count]; i++)
    {
        [_edges addObject:[[P2LGraphEdge alloc] initWithStart:[lastPoint CGPointValue] andEnd:[nextPoint CGPointValue]]];
        
        lastPoint = [_allPoints objectAtIndex:i];
        
        if (i + 1 < [_allPoints count])
        {
            nextPoint = [_allPoints objectAtIndex:i + 1];
        }
    }
    if (closed)
    {
        NSValue *nextPoint = [_allPoints objectAtIndex:0];
        [_edges addObject:[[P2LGraphEdge alloc] initWithStart:[lastPoint CGPointValue] andEnd:[nextPoint CGPointValue]]];
    }
}

- (int)indexOfPoint:(CGPoint)somePoint
{
    NSArray *allPoints = [self allPoints];
    
    int pointIndex = -1;
    
    for (int i = 0; i < [allPoints count]; i++)
    {
        NSValue *thisValue = [allPoints objectAtIndex:i];
        CGPoint thisPoint = [thisValue CGPointValue];
        
        if (CGPointEqualToPoint(thisPoint, somePoint))
        {
            pointIndex = i;
            break;
        }
    }
    
    return pointIndex;
}

- (P2LGraphPath *)shortestPathBetweenLeftPath:(P2LGraphPath *)leftPath andRightPath:(P2LGraphPath *)rightPath toPointInsidePath:(P2LGraphPath *)adjacentPath
{
    if (self.failSafeCounter > 30)
    {
        // holy shit
        return nil;
    }
    self.failSafeCounter++;
    
    if ([adjacentPath containsPoint:[leftPath endPoint]])
    {
        return leftPath;
    }
    else if ([adjacentPath containsPoint:[rightPath endPoint]])
    {
        return rightPath;
    }
    else
    {
        [leftPath addEdgeToEndPoint:[self pointBeforePoint:[leftPath endPoint]]];
        [rightPath addEdgeToEndPoint:[self pointAfterPoint:[rightPath endPoint]]];
        
        return [self shortestPathBetweenLeftPath:leftPath andRightPath:rightPath toPointInsidePath:adjacentPath];
    }
}

- (NSString *)description
{
    NSString *description = @"P2LGraphPath: \n";
    
    for (P2LGraphEdge *edge in _edges)
    {
        description = [description stringByAppendingFormat:@"\t%@\n", edge];
    }
    
    return description;
}

@end

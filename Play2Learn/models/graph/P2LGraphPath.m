//
//  P2LGraphPath.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphPath.h"

@interface P2LGraphPath ()

// internal array of P2LPathEdges
@property (nonatomic, strong) NSMutableArray *edges;
// internal array of points of thoses edges
@property (nonatomic, strong) NSMutableArray *allPoints;
// counter used to prevent endless recursions
@property (nonatomic, assign) int failSafeCounter;

@end

@implementation P2LGraphPath

#pragma mark - initializers

- (id)initWithEdge:(P2LPathEdge *)startEdge
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

- (id)initWithEdges:(NSArray *)edges
{
    self = [super init];
    if (self)
    {
        //
        _edges = [NSMutableArray new];
        _allPoints = [NSMutableArray new];
        
        for (P2LPathEdge *edge in edges)
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
        
        // fill the edges array from the points array
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

- (P2LPathEdge *)startEdge
{
    return (P2LPathEdge *)[_edges objectAtIndex:0];
}

- (P2LPathEdge *)endEdge
{
    return (P2LPathEdge *)[_edges objectAtIndex:MAX(0, [_edges count] - 1)];
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
        P2LPathEdge *edge = [_edges objectAtIndex:i];
        [vertices addObject:[NSValue valueWithCGPoint:edge.startPoint]];
    }
    P2LPathEdge *edge = [_edges objectAtIndex:MAX(0, [_edges count]-1)];
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

- (CGPoint)centroid
{
    // http://stackoverflow.com/questions/2792443/finding-the-centroid-of-a-polygon
    
    CGPoint centroid = CGPointMake(0, 0);
    double signedArea = 0.0;
    double x0 = 0.0; // Current vertex X
    double y0 = 0.0; // Current vertex Y
    double x1 = 0.0; // Next vertex X
    double y1 = 0.0; // Next vertex Y
    double a = 0.0;  // Partial signed area
    
    // For all vertices except last
    int i = 0;
    for ( i = 0; i < (self.allPoints.count - 1); ++i)
    {
        x0 = ((NSValue *)[self.allPoints objectAtIndex:i]).CGPointValue.x;
        y0 = ((NSValue *)[self.allPoints objectAtIndex:i]).CGPointValue.y;
        x1 = ((NSValue *)[self.allPoints objectAtIndex:i+1]).CGPointValue.x;
        y1 = ((NSValue *)[self.allPoints objectAtIndex:i+1]).CGPointValue.y;
        a = x0 * y1 - x1 * y0;
        signedArea += a;
        centroid.x += (x0 + x1) * a;
        centroid.y += (y0 + y1) * a;
    }
    
    // Do last vertex
    x0 = ((NSValue *)[self.allPoints objectAtIndex:i]).CGPointValue.x;
    y0 = ((NSValue *)[self.allPoints objectAtIndex:i]).CGPointValue.y;
    x1 = ((NSValue *)[self.allPoints objectAtIndex:0]).CGPointValue.x;
    y1 = ((NSValue *)[self.allPoints objectAtIndex:0]).CGPointValue.y;
    a = x0 * y1 - x1 * y0;
    signedArea += a;
    centroid.x += (x0 + x1) * a;
    centroid.y += (y0 + y1) * a;
    
    signedArea *= 0.5;
    centroid.x /= (6.0 * signedArea);
    centroid.y /= (6.0 * signedArea);
    
    return centroid;
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

- (void)addEdge:(P2LPathEdge *)newEdge
{
    if ([_edges count] && !CGPointEqualToPoint([self endPoint], [newEdge startPoint]))
    {
        [NSException raise:NSInternalInconsistencyException format:@"Can only add Edges whose startPoint ist the same as the path' endPoint"];
    }
    else
    {
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
    P2LPathEdge *edge = [[P2LPathEdge alloc] initWithStart:[self endPoint] andEnd:endPoint];
    
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
    
    for (P2LPathEdge *edge in newEdges)
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

- (BOOL)containsEdge:(P2LPathEdge *)someEdge
{
    if (someEdge == nil)
    {
        return NO;
    }
    P2LPathEdge *reversedEdge = [[P2LPathEdge alloc] initWithStart:[someEdge endPoint] andEnd:[someEdge startPoint]];
    
    for (P2LPathEdge *edge in _edges)
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
    for (P2LPathEdge *edge in _edges)
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

- (NSUInteger)indexOfEdge:(P2LPathEdge *)someEdge ignoringDirection:(BOOL)ignoreDirection
{
    if (someEdge == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"edge not inside path"];
    }
    P2LPathEdge *reversedEdge = [[P2LPathEdge alloc] initWithStart:[someEdge endPoint] andEnd:[someEdge startPoint]];
    
    for (int i = 0; i < _edges.count; i++)
    {
        P2LPathEdge *edge  = [_edges objectAtIndex:i];
        
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
        [NSException raise:NSInvalidArgumentException format:@"cannot create path with start and end being the same point"];
        //return [[P2LGraphPath alloc] initWithEdge:[[P2LPathEdge alloc] initWithStart:pointA andEnd:pointB]];
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
                leftPath = [[P2LGraphPath alloc] initWithEdge:[[P2LPathEdge alloc] initWithStart:startPoint andEnd:currentPoint]];
            }
        }
        currentPoint = [self pointAfterPoint:currentPoint];
    }
    // extra handling for path with only one egde
    if (leftPath == nil && !CGPointEqualToPoint(startPoint, CGPointMake(MAXFLOAT, 0.0f)) &&
        CGPointEqualToPoint(currentPoint, pointB))
    {
        return leftPath = [[P2LGraphPath alloc] initWithEdge:[[P2LPathEdge alloc] initWithStart:startPoint andEnd:currentPoint]];
    }
    
    [leftPath addEdgeToEndPoint:currentPoint];
    
    return leftPath;
}

- (P2LGraphPath *)shortestPathFrom:(CGPoint)somePoint toPointInsidePath:(P2LGraphPath *)adjacentPath
{
    if (![self isAdjacentToPath:adjacentPath])
    {
        [NSException raise:NSInvalidArgumentException format:@"path is not adjacent!"];
    }
    
    if (![self containsPoint:somePoint])
    {
        [NSException raise:NSInvalidArgumentException format:@"path does not contain somePoint"];
    }
    
    P2LPathEdge *leftEdge = [[P2LPathEdge alloc] initWithStart:somePoint andEnd:[self pointBeforePoint:somePoint]];
    P2LGraphPath *leftPath = [[P2LGraphPath alloc] initWithEdge:leftEdge];
    
    P2LPathEdge *rightEdge = [[P2LPathEdge alloc] initWithStart:somePoint andEnd:[self pointAfterPoint:somePoint]];
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
    // Check if the path is adjacent, because only adjancent paths can be joined
    if (![self isAdjacentToPath:secondGraph])
    {
        [NSException raise:NSInvalidArgumentException format:@"graph not adjacent!"];
    }
    // This stores the newly created graph
    P2LGraphPath *newPath;
    
    // both graphs
    if (![self isClosed] || ![secondGraph isClosed])
    {
        [NSException raise:NSInvalidArgumentException format:@"can only join closed graphs!"];
    }

    NSMutableArray *myEdges = [[self edges] mutableCopy];
    NSMutableArray *hisEgdes = [[secondGraph edges] mutableCopy];
    
    NSMutableIndexSet *mySet = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *hisSet = [[NSMutableIndexSet alloc] init];
    
    // New approach. We join by deleting mutually shared edges in both
    // graphs and the we connect them at the points they share,
    // which should leave one connected outer graph.
    
    for (int i = 0; i < [self edges].count; i++)
    {
        P2LPathEdge *myEdge = [[self edges] objectAtIndex:i];
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
    
    // make sure the edges are pointing in different directions
    // so dont have to deal with both cases while joining.
    P2LPathEdge *myTest = [myEdges objectAtIndex:[mySet firstIndex]];
    P2LPathEdge *hisTest = [hisEgdes objectAtIndex:[hisSet firstIndex]];
    
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
        P2LPathEdge *currentEdge = [activeEdges objectAtIndex:currentIndex];
        [newEdges addObject:currentEdge];
        
        // now look at how to go forth. Check the if the current edge
        // is connected to the next one.
        int nextIndex = currentIndex == activeEdges.count-1 ? 0 : currentIndex+1;
        P2LPathEdge *nextEdge = [activeEdges objectAtIndex:nextIndex];
        
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
                P2LPathEdge *someEdge = [inactiveEdges objectAtIndex:j];
                
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
        [_edges addObject:[[P2LPathEdge alloc] initWithStart:[lastPoint CGPointValue] andEnd:[nextPoint CGPointValue]]];
        
        lastPoint = [_allPoints objectAtIndex:i];
        
        if (i + 1 < [_allPoints count])
        {
            nextPoint = [_allPoints objectAtIndex:i + 1];
        }
    }
    if (closed)
    {
        NSValue *nextPoint = [_allPoints objectAtIndex:0];
        [_edges addObject:[[P2LPathEdge alloc] initWithStart:[lastPoint CGPointValue] andEnd:[nextPoint CGPointValue]]];
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
    
    for (P2LPathEdge *edge in _edges)
    {
        description = [description stringByAppendingFormat:@"\t%@\n", edge];
    }
    
    return description;
}

@end

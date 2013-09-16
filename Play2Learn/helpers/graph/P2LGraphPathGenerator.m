//
//  P2LGraphPathGenerator.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphPathGenerator.h"



@implementation P2LGraphPathGenerator

// TODO: this only works for squares and retangles with width>height. Add width<height support.

+ (P2LGraphPath *)generatePathInsideRect:(CGRect)bounds withEdgesCount:(int)numEdges
{
    P2LGraphPath *generatedPath;
    CGPoint startPoint = CGPointZero;
    
    CGFloat angle = 360.0f / numEdges;
    CGFloat angleOffset = angle * 0.2;
    
    for (CGFloat currentAngle = 0.0f; currentAngle < 360.f; currentAngle += angle)
    {
        CGFloat min = angle - angleOffset;
        CGFloat max = angle + angleOffset;
        
        CGFloat randAngle = ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
        
        CGFloat randomAngle = (currentAngle + randAngle);
        
        
        CGFloat maxLength = [self maxLengthForAngle:randomAngle insideRect:bounds];
        
        min = maxLength * 0.6f;
        max = maxLength * 0.95f;
        
        CGFloat lengthC = ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
        
        CGPoint position = [self positionInsideRect:bounds withAngle:randomAngle andCLength:lengthC];
        
        
        if (generatedPath == nil)
        {
            if (CGPointEqualToPoint(startPoint, CGPointZero))
            {
                startPoint = position;
            }
            else
            {
                P2LPathEdge *startEdge = [[P2LPathEdge alloc] initWithStart:startPoint andEnd:position];
                generatedPath = [[P2LGraphPath alloc] initWithEdge:startEdge];
            }
        }
        else
        {
            [generatedPath addEdgeToEndPoint:position];
        }
    }
    
    [generatedPath closePath];
    
    return generatedPath;
}

+ (P2LGraphPath *)generatePathWithRadius:(CGFloat)radius minLength:(CGFloat)minLength fromAngle:(CGFloat)startAngle toAngle:(CGFloat)endAngle withNumEdges:(int)numEdges
{
    CGRect bounds = CGRectMake(0, 0, radius * 2.0f, radius * 2.0f);
    
    P2LGraphPath *generatedPath;
    CGPoint startPoint = CGPointZero;
    
    CGFloat anglePortion = (endAngle - startAngle) / (numEdges + 1);
    CGFloat angleBorder = anglePortion / 5.0;
    
    /*
     * Example of how this works. Say you have an angle of 120° and 4 Edges. Then you have to
     * create 5 points, so you split the angle in 5 equal portions => 24° per portion. This
     * leaves the loop with 5 iteration, where you create a random angle between 0° and 24°,
     * 24° and 48°,... and lastly 96° and 120°. For each of the random angles you create a 
     * random length between minLength and radius. Using both the random angle and length you
     * then calculate the position of the point from the midPoint that is reached using the angle
     * and length. That point then gets added to the path and you continue until you have all 5
     * which then get returned as the result.
     */
    for (CGFloat currentAngle = startAngle; currentAngle < endAngle; currentAngle += anglePortion)
    {
        CGFloat min = currentAngle + angleBorder;
        CGFloat max = currentAngle + anglePortion - angleBorder;
        
        CGFloat randomAngle = ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
        
        min = minLength;
        max = radius;
        
        CGFloat lengthC = ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
        
        CGPoint position = [self positionInsideRect:bounds withAngle:randomAngle andCLength:lengthC];
        
        NSLog(@"angle: %f, position %f:%f", randomAngle, position.x, position.y);
        
        if (generatedPath == nil)
        {
            if (CGPointEqualToPoint(startPoint, CGPointZero))
            {
                startPoint = position;
            }
            else
            {
                P2LPathEdge *startEdge = [[P2LPathEdge alloc] initWithStart:startPoint andEnd:position];
                generatedPath = [[P2LGraphPath alloc] initWithEdge:startEdge];
            }
        }
        else
        {
            [generatedPath addEdgeToEndPoint:position];
        }
    }
    
    return generatedPath;
}

+ (NSArray *)generatePathsAroundPath:(P2LGraphPath *)innerPath withMaxLength:(CGFloat)maxLength andNumPaths:(int)numPaths
{
    NSMutableArray *generatedPaths = [NSMutableArray new];
    
    CGPoint midPoint = [innerPath midPoint];
    /*
     * Algorithm:
     *
     * - We grab the midPoint of {innerPath}.
     * - We split 360 degrees by {numPaths} to get the anglePortion.
     *
     * LOOP {numPaths} times:
     *
     * - inside each angle portion we create an arc path.
     * - we then change the coordinate system of that path to fit into 
     *   the coordinate system of {innerPath}.
//     * - We move both path into a bigger coordinate system if any point 
//     *   has a negative x or y coordinate.
     * - From the startPoint of the arc we calculate the one closest to
     *   any point of {innerPath} and mark it as the joinEndPoint.
     * - We do the same for the endPoint of the arc and mark it as the 
     *   nextPoint.
     * - We then ask {innerPath} for a path from nextPoint to joinEndPoint
     *   that is closest to the midPoint of the arc. We do not ask for the
     *   shortest, because that might lead to the wrong path (i.e. the one
     *   adjacent to the arc).
     * - That path gets added to the arc path by joining the endPoint of the
     *   arc with the startPoint of that path and its endPoint with the 
     *   startPoint of the arc. 
     */
    P2LGraphPath *previousPath;
    
    CGFloat startAngle = 0.0f;
    CGFloat anglePortion = 360.0f / (float)numPaths;
    CGFloat endAngle = anglePortion;
    
    for (int i = 0; i < numPaths; i++)
    {
        // create arc
        P2LGraphPath *arcPath = [P2LGraphPathGenerator generatePathWithRadius:maxLength minLength:(maxLength * 0.8f) fromAngle:startAngle toAngle:endAngle withNumEdges:5];
        
        // convert all points into the innerPath's coordinate system
        CGFloat xOffset = (midPoint.x - maxLength);
        CGFloat yOffset = (midPoint.y - maxLength);
        [arcPath movePointsWithXOffset:xOffset andYOffset:yOffset];
        
        // get joinEndPoint and nextPoint
        CGPoint joinEndPoint = [innerPath pointClosestToPoint:[arcPath startPoint]];
        
        if (previousPath && i < numPaths-1)
        {
            // get shared border path from previous path
            CGPoint connectionPoint = [previousPath pointClosestToPoint:[arcPath startPoint]];
            P2LGraphPath *borderPath = [previousPath shortestPathFrom:connectionPoint toPointInsidePath:innerPath];
            
            // flip if needed (it should end in connectionPoint)
            if (!CGPointEqualToPoint(connectionPoint, [borderPath endPoint]))
            {
                [borderPath reversePoints];
                NSLog(@"reversed!");
            }
            // set joinEndPoint for adjacentPath
            joinEndPoint = [borderPath startPoint];
            
            // find connection from arc endPoint to the innerPath
            CGPoint joinStartPoint = [innerPath pointClosestToPoint:[arcPath endPoint]];
            
            // get adjecent path from innerPath, closest to the middle point of the arc.
            int midIndex = (int)floor((float)[arcPath allPoints].count / 2.0f);
            CGPoint arcOuterMidPoint = ((NSValue *)[[arcPath allPoints] objectAtIndex:midIndex]).CGPointValue;
            
            P2LGraphPath *adjacentPath = [innerPath pathFromPointA:joinStartPoint toPointB:joinEndPoint closestToPointC:arcOuterMidPoint];
            
            // now construct the whole path
            [arcPath appendPath:adjacentPath];
            // check if the border is valid
            P2LPathEdge *borderEdge = [[borderPath edges] objectAtIndex:0];
            
            if (![arcPath containsEdge:borderEdge])
            {
                [arcPath appendPath:borderPath];
            }
        }
        else if (previousPath && i == numPaths-1) // last path gets special treatmeant...
        {
            // ...because we have 2 bordering paths
            
            // get shared border path from previous path
            CGPoint connectionPoint = [previousPath pointClosestToPoint:[arcPath startPoint]];
            P2LGraphPath *borderPath = [previousPath shortestPathFrom:connectionPoint toPointInsidePath:innerPath];
            
            // flip if needed (it should end in connectionPoint)
            if (!CGPointEqualToPoint(connectionPoint, [borderPath endPoint]))
            {
                [borderPath reversePoints];
            }
            // set joinEndPoint for adjacentPath
            joinEndPoint = [borderPath startPoint];
            
            // find connection from arc endPoint to the innerPath
            // which is different in this case. It should be bordered to the first path
            P2LGraphPath *firstPath = [generatedPaths objectAtIndex:0];
            // grab the connection point
            connectionPoint = [firstPath pointClosestToPoint:[arcPath endPoint]];
            // from that point get the path to the innerPath
            P2LGraphPath *closingBorderPath = [firstPath shortestPathFrom:connectionPoint toPointInsidePath:innerPath];
            // again reverse it if needed
            if (!CGPointEqualToPoint(connectionPoint, [closingBorderPath startPoint]))
            {
                [closingBorderPath reversePoints];
            }
            CGPoint joinStartPoint = [closingBorderPath endPoint];
            
            // get adjecent path from innerPath, closest to the middle point of the arc.
            int midIndex = (int)floor((float)[arcPath allPoints].count / 2.0f);
            CGPoint arcOuterMidPoint = ((NSValue *)[[arcPath allPoints] objectAtIndex:midIndex]).CGPointValue;
            
            P2LGraphPath *adjacentPath = [innerPath pathFromPointA:joinStartPoint toPointB:joinEndPoint closestToPointC:arcOuterMidPoint];
            
            // now construct the whole path
            if ([[closingBorderPath edges] count] == 1 && [adjacentPath containsEdge:[[closingBorderPath edges] objectAtIndex:0]])
            {
                // TODO: see if we can't ensure this otherwise.
            }
            else
            {
                [arcPath appendPath:closingBorderPath];
            }
            [arcPath appendPath:adjacentPath];
            // check if the border is valid
            P2LPathEdge *borderEdge = [[borderPath edges] objectAtIndex:0];
            
            if (![arcPath containsEdge:borderEdge])
            {
                [arcPath appendPath:borderPath];
            }
            else
            {
                // TODO: wieso passiert es?
            }
        }
        else
        {
            CGPoint nextPoint = [innerPath pointClosestToPoint:[arcPath endPoint]];
            // get adjecent path from innerPath, closest to the middle point of the arc.
            int midIndex = (int)floor((float)[arcPath allPoints].count / 2.0f);
            CGPoint arcOuterMidPoint = ((NSValue *)[[arcPath allPoints] objectAtIndex:midIndex]).CGPointValue;
            
            P2LGraphPath *adjacentPath = [innerPath pathFromPointA:nextPoint toPointB:joinEndPoint closestToPointC:arcOuterMidPoint];
            // connect adjacentPath
            [arcPath appendPath:adjacentPath];
        }
        // and close path
        [arcPath closePath];
        
        // save new path
        [generatedPaths addObject:arcPath];
        
        // next loop setup
        previousPath = arcPath;
        startAngle += anglePortion;
        endAngle += anglePortion;
    }
    
    return generatedPaths;
}

+ (CGFloat)alphaForAngle:(CGFloat)angle
{
    while (angle >= 360.0f)
    {
        angle -= 360.0f;
    }
    CGFloat alpha = 0.0f;
    
    if (angle == 0.0f)
    {
        alpha = 0.0f;
    }
    else if (angle <= 45.0f)
    {
        alpha = angle;
    }
    else if (angle <= 90.0f)
    {
        alpha = 90.0f - angle;
    }
    else if (angle <= 135.0f)
    {
        alpha = angle - 90.0f;
    }
    else if (angle <= 180.0f)
    {
        alpha = 180.0f - angle;
    }
    else if (angle <= 225.0f)
    {
        alpha = angle - 180.0f;
    }
    else if (angle <= 270.0f)
    {
        alpha = 270.0f - angle;
    }
    else if (angle <= 315.0f)
    {
        alpha = angle - 270.0f;
    }
    else
    {
        alpha = 360.0f - angle;
    }
    
    return alpha;
}

// TODO: this only works for squares and retangles with width>height. Add width<height support.

+ (CGFloat)maxLengthForAngle:(CGFloat)angle insideRect:(CGRect)bounds
{
    CGFloat width = bounds.size.width / 2.0f;
    CGFloat height = bounds.size.height / 2.0f;
    
    
    
    CGFloat a = width;
    CGFloat b = height;
    CGFloat c = sqrtf(a * a + b * b);
    
    // α = arccos( (b² + c² - a²) / 2bc )
    CGFloat criticalAngle_1 = RAD2DEG(asin(a / c));
    CGFloat criticalAngle_2 = 180.0f - criticalAngle_1;
    CGFloat criticalAngle_3 = 180.0f + criticalAngle_1;
    CGFloat criticalAngle_4 = 360.0f - criticalAngle_1;
    
    while (angle >= 360.0f)
    {
        angle -= 360.0f;
    }
    if (angle == 0.0f)
    {
        return height;
    }
    else if (angle < criticalAngle_1)
    {
        // c = b / cos(alpha)
        return (height / cosf(DEG2RAD(angle)));
    }
    else if (angle == criticalAngle_1 || angle == criticalAngle_2 || angle == criticalAngle_3 || angle == criticalAngle_4)
    {
        return sqrtf(width * width + height * height);
    }
    else if (angle < 90.0f)
    {
        // c = b / cos(alpha)
        angle = 90.0f - angle;
        return (width / cosf(DEG2RAD(angle)));
    }
    else if (angle == 90.0f)
    {
        return width;
    }
    else if (angle < criticalAngle_2)
    {
        // c = b / cos(alpha)
        angle = angle - 90.0f;
        return (width / cosf(DEG2RAD(angle)));
    }
    else if (angle < 180.0f)
    {
        // c = b / cos(alpha)
        angle = 180.0f - angle;
        return (height / cosf(DEG2RAD(angle)));
    }
    else if (angle == 180.0f)
    {
        return height;
    }
    else if (angle < criticalAngle_3)
    {
        // c = b / cos(alpha)
        angle = angle - 180.0f;
        return (height / cosf(DEG2RAD(angle)));
    }
    else if (angle < 270.0f)
    {
        // c = b / cos(alpha)
        angle = 270.0f - angle;
        return (width / cosf(DEG2RAD(angle)));
    }
    else if (angle == 270.0f)
    {
        return width;
    }
    else if (angle < criticalAngle_4)
    {
        // c = b / cos(alpha)
        angle = angle - 270.0f;
        return (width / cosf(DEG2RAD(angle)));
    }
    else
    {
        // c = b / cos(alpha)
        angle = 360.0f - angle;
        return (height / cosf(DEG2RAD(angle)));
    }
}

// TODO: this only works for squares and retangles with width>height. Add width<height support.

+ (CGPoint)positionInsideRect:(CGRect)bounds withAngle:(CGFloat)angle andCLength:(CGFloat)lengthC
{
    while (angle >= 360.0f)
    {
        angle -= 360.0f;
    }
    
    CGFloat alpha = [self alphaForAngle:angle];
    
//    CGFloat width = bounds.size.width / 2.0f;
//    CGFloat height = bounds.size.height / 2.0f;
//    
//    CGFloat a = width;
//    CGFloat b = height;
//    CGFloat c = sqrtf(a * a + b * b);
//    
//    CGFloat criticalAngle_1 = RAD2DEG(asin(a / c));
//    CGFloat criticalAngle_2 = 180.0f - criticalAngle_1;
//    CGFloat criticalAngle_3 = 180.0f + criticalAngle_1;
//    CGFloat criticalAngle_4 = 360.0f - criticalAngle_1;
    
    CGPoint center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f);
    
    // a = c * sin(alpha)
    CGFloat lengthA = lengthC * sinf(DEG2RAD(alpha));
    // b = c * cos(alpha)
    CGFloat lengthB = lengthC * cosf(DEG2RAD(alpha));
    
    if (bounds.size.width >= bounds.size.height)
    {
        if (angle <= 45)
        {
            center.x += lengthA;
            center.y -= lengthB;
        }
//        else if (angle < criticalAngle_1)
//        {
//            center.x += lengthB;
//            center.y -= lengthA;
//        }
        else if (angle <= 90.0f)
        {
            center.x += lengthB;
            center.y -= lengthA;
        }
//        else if (angle <= criticalAngle_2)
//        {
//            center.x += lengthB;
//            center.y += lengthA;
//        }
        else if (angle <= 135.0f)
        {
            center.x += lengthB;
            center.y += lengthA;
        }
        else if (angle <= 180.0f)
        {
            center.x += lengthA;
            center.y += lengthB;
        }
        else if (angle <= 225.0f)
        {
            center.x -= lengthA;
            center.y += lengthB;
        }
//        else if (angle < criticalAngle_3)
//        {
//            center.x -= lengthB;
//            center.y += lengthA;
//        }
        else if (angle <= 270.0f)
        {
            center.x -= lengthB;
            center.y += lengthA;
        }
//        else if (angle <= criticalAngle_4)
//        {
//            center.x -= lengthB;
//            center.y -= lengthA;
//        }
        else if (angle <= 315.0f)
        {
            center.x -= lengthB;
            center.y -= lengthA;
        }
        else
        {
            center.x -= lengthA;
            center.y -= lengthB;
        }
    }
    else
    {
        if (angle <= 45)
        {
            center.x += lengthA;
            center.y -= lengthB;
        }
        else if (angle <= 90.0f)
        {
            center.x += lengthB;
            center.y -= lengthA;
        }
        else if (angle <= 135.0f)
        {
            center.x += lengthB;
            center.y += lengthA;
        }
        else if (angle <= 180.0f)
        {
            center.x += lengthA;
            center.y += lengthB;
        }
        else if (angle <= 225.0f)
        {
            center.x -= lengthA;
            center.y += lengthB;
        }
        
        else if (angle <= 270.0f)
        {
            center.x -= lengthB;
            center.y += lengthA;
        }
        else if (angle <= 315.0f)
        {
            center.x -= lengthB;
            center.y -= lengthA;
        }
        else
        {
            center.x -= lengthA;
            center.y -= lengthB;
        }
    }
    
    
    if (center.x < 0 || center.y < 0 || center.x > bounds.size.width || center.y > bounds.size.height)
    {
        [NSException raise:NSInternalInconsistencyException format:@"created point outside of bounds"];
    }
    
    return center;
}

@end

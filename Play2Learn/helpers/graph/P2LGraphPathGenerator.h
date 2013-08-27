//
//  P2LGraphPathGenerator.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2LGraphPath.h"

#define RAD2DEG(radian) (radian * 180.0/M_PI)

#define DEG2RAD(degrees) (degrees * M_PI/180.0)

#define ARC4RANDOM_MAX 0x100000000

@interface P2LGraphPathGenerator : NSObject

+ (P2LGraphPath *)generatePathInsideRect:(CGRect)bounds withEdgesCount:(int)numEdges;

+ (P2LGraphPath *)generatePathWithRadius:(CGFloat)radius minLength:(CGFloat)minLength fromAngle:(CGFloat)startAngle toAngle:(CGFloat)endAngle withNumEdges:(int)numEdges;

+ (NSArray *)generatePathsAroundPath:(P2LGraphPath *)innerPath withMaxLength:(CGFloat)maxLength andNumPaths:(int)numPaths;

+ (CGFloat)maxLengthForAngle:(CGFloat)angle insideRect:(CGRect)bounds;

+ (CGPoint)positionInsideRect:(CGRect)bounds withAngle:(CGFloat)angle andCLength:(CGFloat)lengthC;

+ (CGFloat)alphaForAngle:(CGFloat)angle;



@end

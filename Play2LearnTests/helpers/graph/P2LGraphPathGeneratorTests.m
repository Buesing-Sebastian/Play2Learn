//
//  P2LGraphPathGeneratorTests.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 25.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LGraphPathGeneratorTests.h"
#import "P2LGraphPathGenerator.h"

@implementation P2LGraphPathGeneratorTests


- (void)testMaxLengthForAngle
{
    CGRect testRect = CGRectMake(0, 0, 240, 180);
    
    CGFloat length;
    
    length = [P2LGraphPathGenerator maxLengthForAngle:0.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 90.0f, 0.01f, @"Length for 0° should be 90");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:5.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 90.34f, 0.01f, @"Length for 5° should be 90.34");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:53.13f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 150.0f, 0.01f, @"Length for 53.13° should be 150");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:55.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 146.49f, 0.01f, @"Length for 55° should be 146.49");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:90.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 120.0f, 0.01f, @"Length for 90° should be 120");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:99.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 121.49f, 0.01f, @"Length for 99° should be 121.49");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:126.87f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 150.0f, 0.01f, @"Length for 126.87° should be 150");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:150.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 103.92f, 0.01f, @"Length for 150° should be 103.92f");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:180.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 90.0f, 0.01f, @"Length for 180° should be 90");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:195.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 93.17f, 0.01f, @"Length for 195° should be 93.17");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:233.13f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 150.0f, 0.01f, @"Length for 223.13° should be 150");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:243.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 134.67f, 0.01f, @"Length for 233° should be 150.25");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:270.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 120.0f, 0.01f, @"Length for 270° should be 120");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:280.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 121.85f, 0.01f, @"Length for 280° should be 121.85f");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:306.87f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 150.0f, 0.01f, @"Length for 306.87° should be 150");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:335.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 99.30f, 0.01f, @"Length for 335° should be 99.30");
    
    
    length = [P2LGraphPathGenerator maxLengthForAngle:360.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 90.0f, 0.01f, @"Length for 360° should be 90");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:373.0f insideRect:testRect];
    STAssertEqualsWithAccuracy(length, 92.36f, 0.01f, @"Length for 373° should be 92.36");
}

- (void)testAlphaForAngle
{
    CGFloat alpha;
    
    alpha = [P2LGraphPathGenerator alphaForAngle:0.0f];
    STAssertEqualsWithAccuracy(alpha, 0.0f, 0.01f, @"Alpha for angle 0° should be 0");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:5.0f];
    STAssertEqualsWithAccuracy(alpha, 5.0f, 0.01f, @"Alpha for angle 5° should be 5");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:53.13f];
    STAssertEqualsWithAccuracy(alpha, 36.87f, 0.01f, @"Alpha for angle 53.13° should be 36.87");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:55.0f];
    STAssertEqualsWithAccuracy(alpha, 35.0f, 0.01f, @"Alpha for angle 55° should be 35");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:90.0f];
    STAssertEqualsWithAccuracy(alpha, 0.0f, 0.01f, @"Alpha for angle 90° should be 0");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:99.0f];
    STAssertEqualsWithAccuracy(alpha, 9.0f, 0.01f, @"Alpha for angle 99° should be 9");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:126.87f];
    STAssertEqualsWithAccuracy(alpha, 36.87f, 0.01f, @"Alpha for angle 126.87° should be 36.87");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:150.0f];
    STAssertEqualsWithAccuracy(alpha, 30.0f, 0.01f, @"Alpha for angle 150° should be 30");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:180.0f];
    STAssertEqualsWithAccuracy(alpha, 0.0f, 0.01f, @"Alpha for angle 180° should be 0");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:195.0f];
    STAssertEqualsWithAccuracy(alpha, 15.0f, 0.01f, @"Alpha for angle 195° should be 15");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:233.13f];
    STAssertEqualsWithAccuracy(alpha, 36.87f, 0.01f, @"Alpha for angle 233.13° should be 36.87");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:243.0f];
    STAssertEqualsWithAccuracy(alpha, 27.0f, 0.01f, @"Alpha for angle 243° should be 27");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:270.0f];
    STAssertEqualsWithAccuracy(alpha, 0.0f, 0.01f, @"Alpha for angle 270° should be 0");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:280.0f];
    STAssertEqualsWithAccuracy(alpha, 10.0f, 0.01f, @"Alpha for angle 280° should be 10");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:306.87f];
    STAssertEqualsWithAccuracy(alpha, 36.87f, 0.01f, @"Alpha for angle 306.87° should be 36.87");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:335.0f];
    STAssertEqualsWithAccuracy(alpha, 25.0f, 0.01f, @"Alpha for angle 335° should be 25");
    
    alpha = [P2LGraphPathGenerator alphaForAngle:360.0f];
    STAssertEqualsWithAccuracy(alpha, 0.0f, 0.01f, @"Alpha for angle 360° should be 0");
}

- (void)testPositionInsideRect
{
    CGRect testRect = CGRectMake(0, 0, 240, 180);
    
    CGFloat length;
    CGPoint position;
    
    CGFloat a = testRect.size.width / 2.0f;
    CGFloat b = testRect.size.height / 2.0f;
    CGFloat c = sqrtf(a * a + b * b);
    
    CGFloat criticalAngle_1 = RAD2DEG(asin(a / c));
    CGFloat criticalAngle_2 = 180.0f - criticalAngle_1;
    CGFloat criticalAngle_3 = 180.0f + criticalAngle_1;
    CGFloat criticalAngle_4 = 360.0f - criticalAngle_1;
    
    length = [P2LGraphPathGenerator maxLengthForAngle:0.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:0.0f andCLength:length * 0.6];
    STAssertEqualsWithAccuracy(position.x, 120.0f, 0.01f, @"Position x for 0° should be 120");
    STAssertEqualsWithAccuracy(position.y, 36.0f, 0.01f, @"Position y for 0° should be 54");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:5.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:5.0f andCLength:length * 0.65];
    STAssertEqualsWithAccuracy(position.x, 125.11f, 0.01f, @"Position x for 5° should be 125.11");
    STAssertEqualsWithAccuracy(position.y, 31.50f, 0.01f, @"Position y for 5° should be 31.51");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:criticalAngle_1 insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:criticalAngle_1 andCLength:length * 0.7];
    STAssertEqualsWithAccuracy(position.x, 203.99f, 0.01f, @"Position x for 53.13° should be 203.99");
    STAssertEqualsWithAccuracy(position.y, 27.0f, 0.01f, @"Position y for 53.13° should be 27");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:55.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:55.0f andCLength:length * 0.75];
    STAssertEqualsWithAccuracy(position.x, 209.99f, 0.01f, @"Position x for 55° should be 209.99");
    STAssertEqualsWithAccuracy(position.y, 26.99f, 0.01f, @"Position y for 55° should be 26.99");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:90.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:90.0f andCLength:length * 0.8];
    STAssertEqualsWithAccuracy(position.x, 216.0f, 0.01f, @"Position x for 90° should be 216");
    STAssertEqualsWithAccuracy(position.y, 90.0f, 0.01f, @"Position y for 90° should be 90");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:99.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:99.0f andCLength:length * 0.85];
    STAssertEqualsWithAccuracy(position.x, 221.99f, 0.01f, @"Position x for 99° should be 221.99");
    STAssertEqualsWithAccuracy(position.y, 106.15f, 0.01f, @"Position y for 99° should be 106.15");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:criticalAngle_2 insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:criticalAngle_2 andCLength:length * 0.9];
    STAssertEqualsWithAccuracy(position.x, 227.99f, 0.01f, @"Position x for 126.87° should be 227.99");
    STAssertEqualsWithAccuracy(position.y, 171.0f, 0.01f, @"Position y for 126.87° should be 171");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:150.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:150.0f andCLength:length * 0.6];
    STAssertEqualsWithAccuracy(position.x, 151.17f, 0.01f, @"Position x for 150° should be 151.17");
    STAssertEqualsWithAccuracy(position.y, 143.99f, 0.01f, @"Position y for 150° should be 143.99");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:180.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:180.0f andCLength:length * 0.65];
    STAssertEqualsWithAccuracy(position.x, 120.0f, 0.01f, @"Position x for 180° should be 120");
    STAssertEqualsWithAccuracy(position.y, 148.50f, 0.01f, @"Position y for 180° should be 148.5");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:195.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:195.0f andCLength:length * 0.7];
    STAssertEqualsWithAccuracy(position.x, 103.12f, 0.01f, @"Position x for 195° should be 103.13");
    STAssertEqualsWithAccuracy(position.y, 152.99f, 0.01f, @"Position y for 195° should be 152.99");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:criticalAngle_3 insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:criticalAngle_3 andCLength:length * 0.75];
    STAssertEqualsWithAccuracy(position.x, 30.01f, 0.01f, @"Position x for 233.13° should be 30.01");
    STAssertEqualsWithAccuracy(position.y, 157.5f, 0.01f, @"Position y for 233.13° should be 157.5");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:243.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:243.0f andCLength:length * 0.8];
    STAssertEqualsWithAccuracy(position.x, 24.0f, 0.01f, @"Position x for 243° should be 24.01");
    STAssertEqualsWithAccuracy(position.y, 138.91f, 0.01f, @"Position y for 243° should be 138.91");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:270.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:270.0f andCLength:length * 0.85];
    STAssertEqualsWithAccuracy(position.x, 18.0f, 0.01f, @"Position x for 270° should be 18");
    STAssertEqualsWithAccuracy(position.y, 90.0f, 0.01f, @"Position y for 270° should be 90");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:280.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:280.0f andCLength:length * 0.9];
    STAssertEqualsWithAccuracy(position.x, 12.0f, 0.01f, @"Position x for 280° should be 12.01");
    STAssertEqualsWithAccuracy(position.y, 70.96f, 0.01f, @"Position y for 280° should be 70.86");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:criticalAngle_4 insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:criticalAngle_4 andCLength:length * 0.85];
    STAssertEqualsWithAccuracy(position.x, 18.01f, 0.01f, @"Position x for 306.87° should be 18.01");
    STAssertEqualsWithAccuracy(position.y, 13.5f, 0.01f, @"Position y for 306.87° should be 13.5");
    
    length = [P2LGraphPathGenerator maxLengthForAngle:335.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:335.0f andCLength:length * 0.8];
    STAssertEqualsWithAccuracy(position.x, 86.43f, 0.01f, @"Position x for 335° should be 86.43");
    STAssertEqualsWithAccuracy(position.y, 18.00f, 0.01f, @"Position y for 335° should be 18.01");
    
    
    length = [P2LGraphPathGenerator maxLengthForAngle:360.0f insideRect:testRect];
    position = [P2LGraphPathGenerator positionInsideRect:testRect withAngle:360.0f andCLength:length * 0.75];
    STAssertEqualsWithAccuracy(position.x, 120.0f, 0.01f, @"Position x for 360° should be 120");
    STAssertEqualsWithAccuracy(position.y, 22.5f, 0.01f, @"Position y for 360° should be 67.5");
}

@end

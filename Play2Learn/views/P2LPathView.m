//
//  P2LPathView.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.05.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LPathView.h"

@interface P2LPathView ()

@property (nonatomic, strong) UIImage *texture;

@end

@implementation P2LPathView

/*
 * Helper method that draws a single line from one point to another.
 */
void drawStroke(CGContextRef context, CGFloat strokeWidth, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, strokeWidth);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (id)initWithFrame:(CGRect)frame andPath:(P2LGraphPath *)path
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _path = path;
        self.backgroundColor = [UIColor clearColor];
        self.pathColor = [UIColor redColor];
        self.strokeWidth = 2;
        self.occupiedByEnemy = YES;
        _forcesCount = 0;
        
        self.forcesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.forcesLabel.center = CGPointMake((self.frame.size.width / 2.0f), (self.frame.size.height / 2.0f));
        self.forcesLabel.backgroundColor = [UIColor clearColor];
        self.forcesLabel.text = @"0";
        self.forcesLabel.textAlignment = NSTextAlignmentCenter;
        self.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        self.forcesLabel.textColor = [UIColor redColor];
        
        CGPoint centroid = [self.path centroid];
        
        self.forcesLabel.center = CGPointMake(centroid.x - self.frame.origin.x, centroid.y - self.frame.origin.y);
        
        self.texture = [UIImage imageNamed:@"grassland.png"];

        [self addSubview:self.forcesLabel];
    }
    return self;
}

/*
 * Method used to draw the view.
 */
-(void)drawRect:(CGRect)rect
{
    CGFloat xOffset = self.frame.origin.x;
    CGFloat yOffset = self.frame.origin.y;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat height = self.bounds.size.height;
    CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    
    if (self.selected)
    {
        CGContextMoveToPoint(context, [_path startPoint].x - xOffset, height - ([_path startPoint].y - yOffset));
        
        for (P2LPathEdge *edge in [_path edges])
        {
            CGContextAddLineToPoint(context, [edge endPoint].x - xOffset, height - ([edge endPoint].y - yOffset));
        }
    }
    
    UIColor *selectedColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5f];
    CGContextSetFillColorWithColor(context, selectedColor.CGColor);
    CGContextFillPath(context);
    
    for (P2LPathEdge *edge in [_path edges])
    {
        CGPoint startPoint = [edge startPoint];
        CGPoint endPoint = [edge endPoint];
        
        startPoint.x = startPoint.x - xOffset;
        startPoint.y = height - (startPoint.y - yOffset);
        endPoint.x = endPoint.x - xOffset;
        endPoint.y = height - (endPoint.y - yOffset);
        
        drawStroke(UIGraphicsGetCurrentContext(), self.strokeWidth, startPoint, endPoint, self.pathColor.CGColor);
    }
    
    
}


@end

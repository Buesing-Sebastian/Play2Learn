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
        self.pathColor = [UIColor blueColor];
        self.strokeWidth = 2;
        self.occupiedByEnemy = YES;
        _forcesCount = 0;
        
        self.forcesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.forcesLabel.center = CGPointMake((self.frame.size.width / 2.0f), (self.frame.size.height / 2.0f));
        self.forcesLabel.backgroundColor = [UIColor clearColor];
        self.forcesLabel.text = @"0";
        self.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        self.forcesLabel.textColor = [UIColor redColor];
        
        self.texture = [UIImage imageNamed:@"grassland.png"];

        [self addSubview:self.forcesLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat xOffset = self.frame.origin.x;
    CGFloat yOffset = self.frame.origin.y;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat height = self.bounds.size.height;
    CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextBeginTransparencyLayer(context, NULL);
    
//    if (self.selected)
//    {
    
        //CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
        //CGContextSetLineWidth(context, 1.0);
        //CGContextSetStrokeColorWithColor(context, self.pathColor.CGColor);
        CGContextMoveToPoint(context, [_path startPoint].x - xOffset, height - ([_path startPoint].y - yOffset));
        
        for (P2LGraphEdge *edge in [_path edges])
        {
            CGContextAddLineToPoint(context, [edge endPoint].x - xOffset, height - ([edge endPoint].y - yOffset));
        }
    
        //UIColor *selectedColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8f];
        //CGContextSetFillColorWithColor(context, selectedColor.CGColor);
//        CGContextFillPath(context);
    //CGContextStrokePath(context);
    CGContextClosePath(context);
    CGContextSaveGState(context);
    
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 512, 512), self.texture.CGImage);
    
    //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    //[self.texture drawInRect:self.bounds];
    
//    CGContextEndTransparencyLayer(context);
//    }
//    else
//    {
        if (self.selected)
        {
            CGContextRef context= UIGraphicsGetCurrentContext();
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextSetLineWidth(context, 1.0);
            CGContextMoveToPoint(context, [_path startPoint].x - xOffset, height - ([_path startPoint].y - yOffset));
            
            for (P2LGraphEdge *edge in [_path edges])
            {
                CGContextAddLineToPoint(context, [edge endPoint].x - xOffset, height - ([edge endPoint].y - yOffset));
            }
            
            UIColor *selectedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
            CGContextSetFillColorWithColor(context, selectedColor.CGColor);
            CGContextFillPath(context);
        }
//    }
    for (P2LGraphEdge *edge in [_path edges])
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

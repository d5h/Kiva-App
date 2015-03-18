//
//  StatDetailCell.m
//  Kiva App
//
//  Created by David Rajan on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "StatDetailCell.h"

@implementation StatDetailCell

- (void)awakeFromNib {
//    self.containerView.layer.borderWidth = 2.0f;
//    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.cornerRadius = 100.0f;

}

- (void)_drawRect:(CGRect)rect
{
    
    [self drawCircle:0.0 end:1.0 color:[UIColor colorWithRed:127/255.0 green:173/255.0 blue:76/255.0 alpha:1.0f] bgColor:[UIColor colorWithRed:127/255.0 green:173/255.0 blue:76/255.0 alpha:1.0f]];
//    [self drawCircl:0.5 end:1.0 color:[UIColor redColor] bgColor:[UIColor blueColor]];
   
}

- (void) drawCircle:(float)start end:(float)end color:(UIColor*)color bgColor:(UIColor*)bgColor{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.8);
    
    CGFloat startAngle = start * 2 * M_PI - M_PI/2;
    CGFloat endAngle = end * 2 * M_PI - M_PI/2;
    
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.width/2, self.bounds.size.height/2 - 30, startAngle, endAngle, NO);
    
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
}

@end

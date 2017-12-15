//
//  UIView+drawLine.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UIView+drawLine.h"

@implementation UIView (drawLine)
+(UIView*)drawSeparatorLineByRect:(CGRect)frame{
    UIView *view = [UIView new];
    //[view drawRect:frame];
    [view setNeedsDisplay];
    return view;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 4);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 239.7 / 255.0, 239.7 / 255.0, 239.7 / 255.0, 0.6);  //线的颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 20, 0);  //起点坐标
    CGContextAddLineToPoint(context, rect.size.width, 0);   //终点坐标
    
    CGContextStrokePath(context);
}
@end

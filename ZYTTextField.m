//
//  ZYTTextField.m
//  闲么
//
//  Created by 邹应天 on 16/1/26.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "ZYTTextField.h"

@implementation ZYTTextField
-(void)awakeFromNib{
    [self setBorderStyle:UITextBorderStyleRoundedRect];
}
- (void)createWithImage:(UIImage *)image andTitle:(NSString *)title{
    UIImageView *magnifyImgV = [[UIImageView alloc]initWithImage:image];
    magnifyImgV.frame = CGRectMake(5, 10, 20, 20);
    magnifyImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:magnifyImgV];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(5+20+10, 10, 45, 20)];
    titleLb.text = title;
    titleLb.textColor = [UIColor whiteColor];
    [titleLb setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:titleLb];

}
//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
}
//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
//    [[UIColor colorWithWhite:0.9 alpha:0.8] setFill];
    CGRect inset = CGRectMake(bounds.origin.x+80, bounds.origin.y, bounds.size.width -40, bounds.size.height);//更好理解些
    return inset;
}
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+35+45, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}
-(CGRect)editingRectForBounds:(CGRect)bounds
{    
    CGRect inset = CGRectMake(bounds.origin.x +45+35, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}
@end

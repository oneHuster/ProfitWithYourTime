//
//  loginTextField.m
//  闲么
//
//  Created by 邹应天 on 16/4/21.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "loginTextField.h"

@implementation loginTextField
- (id)initWithImage:(UIImage*)image andTitle:(NSString*)title{
    self = [super init];
    self.layer.cornerRadius = 2;
    [self setFont:[UIFont systemFontOfSize:11]];
    self.tintColor = [UIColor blackColor];
    self.textColor  = [UIColor whiteColor];
    UIImageView *magnifyImgV = [[UIImageView alloc]initWithImage:image];
    magnifyImgV.frame = CGRectMake(5, 10, 20, 20);
    magnifyImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:magnifyImgV];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(5+20+10, 10, 45, 20)];
    titleLb.text = title;
    [titleLb setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:titleLb];
    return self;
}
//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
}
//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    //NSLog(@"%@",NSStringFromCGRect(bounds));
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
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +45+35, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}
@end

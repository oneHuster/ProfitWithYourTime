//
//  KTDsearchBox.m
//  闲么
//
//  Created by 邹应天 on 16/4/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "KTDsearchBox.h"

@implementation KTDsearchBox
- (id)init{
    self = [super init];
    self.layer.cornerRadius = 2;
    [self setFont:[UIFont systemFontOfSize:11]];
    self.tintColor = [UIColor whiteColor];
    self.textColor  = [UIColor whiteColor];
    UIImageView *magnifyImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"magnifyIcon"]];
    magnifyImgV.frame = CGRectMake(6, 4, 17, 17);
    magnifyImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:magnifyImgV];
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
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -40, bounds.size.height);//更好理解些
    return inset;
}
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +30, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}

@end

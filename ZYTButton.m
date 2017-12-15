//
//  ZYTButton.m
//  闲么
//
//  Created by 邹应天 on 16/4/10.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "ZYTButton.h"

@implementation ZYTButton
- (CGRect)titleRectForContentRect: (CGRect)contentRect // 控制label显示在哪和大小
{
    return CGRectMake(0, contentRect.size.width, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}
- (CGRect)imageRectForContentRect: (CGRect)contentRect // 控制image显示在哪和大小
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}
@end

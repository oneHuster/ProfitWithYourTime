//
//  nine_gridImageView.m
//  weibo
//
//  Created by 邹应天 on 15/12/5.
//  Copyright © 2015年 邹应天. All rights reserved.
//

#import "nine_gridImageView.h"
#import "ZYTmagnifyBrowser.h"
@implementation nine_gridImageView
-(void)initialize{
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(magnifyImage)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
}
-(void)magnifyImage{
    NSLog(@"局部放大");
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    ZYTmagnifyBrowser *magnify=[[ZYTmagnifyBrowser alloc]initWithFrame:window.bounds];
    [magnify showImage:self];
    [window addSubview:magnify];
}

@end

//
//  popupV.m
//  闲么
//
//  Created by 邹应天 on 16/4/1.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "popupV.h"

@implementation popupV
+ (popupV*)initWithErrorInfo:(NSString *)string{
    popupV *newone = [[popupV alloc]initWithFrame:CGRectMake( SCREEN_WIDTH/2 - 100,SCREEN_HEIGHT-200, 200, 50)];
    newone.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.7];
    newone.layer.cornerRadius  = 5;
   
    UILabel *errorLb = [[UILabel alloc]initWithFrame:newone.bounds];
    errorLb.textAlignment = NSTextAlignmentCenter;
    errorLb.lineBreakMode = NSLineBreakByWordWrapping;
    [errorLb setNumberOfLines:0];
    errorLb.font = [UIFont systemFontOfSize:12];

    
    [newone addSubview:errorLb];
    if (string)
        errorLb.text = string;
    else
        errorLb.text = @"网络连接失败";
    
    errorLb.textColor = Tint_COLOR;
    return newone;
}

+ (popupV*)initWithWarning:(NSString *)string{
    popupV *newone = [[popupV alloc]initWithFrame:CGRectMake( SCREEN_WIDTH/2 - 100,SCREEN_HEIGHT-200, 200, 50)];
    newone.layer.cornerRadius  = 5;
    newone.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.7];
    UILabel *errorLb = [[UILabel alloc]initWithFrame:newone.bounds];
    errorLb.textAlignment = NSTextAlignmentCenter;
    [newone addSubview:errorLb];
    if (string)
        errorLb.text = string;
    else
        errorLb.text = @"请将信息填写完整";
    
    errorLb.textColor = Tint_COLOR;
    return newone;
}

- (void)animationPresentAfterTimeInterval:(NSTimeInterval)present AndDelay:(NSTimeInterval)delay{
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.6 delay:present options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.6 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

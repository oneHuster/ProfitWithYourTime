//
//  ZYTShadowView.m
//  闲么
//
//  Created by 邹应天 on 16/1/27.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "ZYTShadowView.h"

@implementation ZYTShadowView

/*
// Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.*/

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(0, 0);

}

@end

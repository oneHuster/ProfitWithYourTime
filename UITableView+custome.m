//
//  UITableView+custome.m
//  闲么
//
//  Created by 邹应天 on 16/2/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UITableView+custome.h"

@implementation UITableView (custome)
-(void)modifyTheHeaderViewLabel{
    NSLog(@"%@",self.tableHeaderView.subviews);
//    for (UIView *label in self.tableHeaderView.subviews) {
////        if ([label isKindOfClass:[UILabel class]]) {
//////            label.font = [UIFont systemFontOfSize:10];
//////            label.textColor = Font_COLOR;
////        }
//        
//    }
}
@end

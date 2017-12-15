//
//  UITableViewCell+commonCELL.m
//  闲么
//
//  Created by 邹应天 on 16/2/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UITableViewCell+commonCELL.h"

@implementation UITableViewCell (commonCELL)
-(void)clearTheItems{
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;

    NSInteger i=0; 
    NSArray *arr = self.contentView.subviews;
    while (i<arr.count) {
        if ([arr[i] isKindOfClass:[UIImageView class]]) {
            [arr[i] removeFromSuperview];
        }
        if ([arr[i]isKindOfClass:[UISwitch class]]) {
            [arr[i] removeFromSuperview];
        }
        i++;
    }
    
    self.backgroundColor = [UIColor whiteColor];
}
@end

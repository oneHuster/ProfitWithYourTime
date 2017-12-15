//
//  UIViewController+notificationForTabbar.m
//  闲么
//
//  Created by 邹应天 on 16/2/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UIViewController+notificationForTabbar.h"

@implementation UIViewController (notificationForTabbar)
-(void)hideTheTabbar{
    self.tabBarController.tabBar.hidden = YES;
   // [self.tabBarController.tabBar removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideBarItems" object:nil];
}
-(void)presentTabbar{
    self.tabBarController.tabBar.hidden = NO;
    //[self.tabBarController.tabBar removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"presentBarItems" object:nil];
}
@end

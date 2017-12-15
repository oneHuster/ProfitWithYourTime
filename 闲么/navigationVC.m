//
//  navigationVC.m
//  闲么
//
//  Created by 邹应天 on 16/2/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "navigationVC.h"
#import "UINavigationItem+CustomeBackButton.h"

@implementation navigationVC
- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    
    //self.navigationItem.backBarButtonItem = [UINavigationItem load];
    
    return self;
}
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}
@end

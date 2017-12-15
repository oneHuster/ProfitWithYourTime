//
//  UINavigationController+completionHandle.m
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UINavigationController+completionHandle.h"

@implementation UINavigationController (completionHandle)

- (void)completionhandler_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popViewControllerAnimated:animated];
    [CATransaction commit];
}
@end

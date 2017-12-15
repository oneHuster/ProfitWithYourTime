//
//  UINavigationController+completionHandle.h
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (completionHandle)
/*push handle
- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion;
 */


/*pop handle*/
- (void)completionhandler_popViewControllerAnimated:(BOOL)animated
                                  completion:(void (^)(void))completion;
@end

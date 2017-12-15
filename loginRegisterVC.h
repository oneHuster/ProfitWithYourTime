//
//  loginRegisterVC.h
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
typedef NS_ENUM(NSInteger, ZYTUserState)
{
    ZYTUserStateToLogin,
    ZYTUserStateToRegister,
    ZYTUserStateLogged,
    ZYTUserStateRegistered
};
#import <UIKit/UIKit.h>

@interface loginRegisterVC : UIViewController
@property ZYTUserState theUserState;
@end

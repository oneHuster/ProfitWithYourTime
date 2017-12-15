//
//  AppDelegate.m
//  闲么
//
//  Created by 邹应天 on 16/1/21.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "AppDelegate.h"
#import "tabbarVC_custome.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "AlipayHeader.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
//Links Native SDK use
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <ShareSDKUI/ShareSDKUI.h>

//QQ SDK header file
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//Wechat SDK header file
#import "WXApi.h"

//SinaWeibo SDK header file
#import "WeiboSDK.h"
@interface AppDelegate ()
@property BMKMapManager* mapManager;
@property tabbarVC_custome *tabController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //全局修改状态栏的颜色。
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //全局修改所有的navigationBar的风格
    [[UINavigationBar appearance]setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //修改返回按钮tint
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    //取消bar的阴影
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc]init]];
    //[UINavigationItem load];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage new]];
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"backItem"]];
    
    
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    _tabController=[[tabbarVC_custome alloc]init];
    //首次启动
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"])
    {
        [_tabController createUserGuideV];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
    }
    
    //后台获取消息
    [[UIApplication sharedApplication]setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //百度地图授权
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"YHIuw9jBrGItIdBFApinWHAG"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //授权登录
    [ShareSDK registerApp:@"10ade5db87f70" activePlatforms: @[@(SSDKPlatformTypeSinaWeibo),
          @(SSDKPlatformTypeMail),
          @(SSDKPlatformTypeSMS),
          @(SSDKPlatformTypeCopy),
          @(SSDKPlatformTypeWechat),
          @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [ShareSDKConnector connectWeChat:[WXApi class]];
                      break;
                  case SSDKPlatformTypeQQ:
                      [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                      break;
                  default:
                      break;
              }
          } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                   appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                   redirectUri:@"http://www.sharesdk.cn"
                   authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                    appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105268088"
                       appKey:@"QwwTZ52axSY6YEYG"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    self.window.rootViewController=_tabController;

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"disPublishButton" object:nil];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

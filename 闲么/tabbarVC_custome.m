//
//  tabbarVC_custome.m
//  闲么
//
//  Created by 邹应天 on 16/1/26.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "tabbarVC_custome.h"
#import "publishModalVC.h"
#import "SDCycleScrollView.h"


#import "homePageVC.h"
#import "profileVC.h"
#import "messageVC.h"
#import "publishVC.h"
#import "communityVC.h"
#import "navigationVC.h"


@interface tabbarVC_custome()<SDCycleScrollViewDelegate>
@property UINavigationController *publishNav;
@property publishModalVC *publishMVC;
@property UIButton *entryButton;
@property homePageVC *homepageVC;
@end
@implementation tabbarVC_custome

-(id)init{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addButtonPressedAndPresentAView) name:@"addButton" object:nil];
//        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backButtonPressedAndDisPresentView) name:@"disPublishButton" object:nil];
//
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidesBarAndItems) name:@"hideBarItems" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentBarAndItems) name:@"presentBarItems" object:nil];
        
        self.tabBar.tintColor = Tint_COLOR;
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.translucent = NO;
       
        [self createTheViewControllers];
    
    }
    return self;
}
-(void)createTheViewControllers{
     self.homepageVC =[[homePageVC alloc]init];
    navigationVC *tabbar_homePage=[[navigationVC alloc]initWithRootViewController:self.homepageVC];
        tabbar_homePage.tabBarItem.title=@"首页";
        tabbar_homePage.tabBarItem.image = [UIImage imageNamed:@"tabbar_homepage.png"];
    
    communityVC *communityvc = [[communityVC alloc]init];
    navigationVC *tabbar_community=[[navigationVC alloc]initWithRootViewController:communityvc];
        tabbar_community.tabBarItem.title=@"圈子";
        tabbar_community.tabBarItem.image=[UIImage imageNamed:@"tabbar_circle.png"];
    
    publishVC *compose = [[publishVC alloc]init];
    //publishVC *compose = nil;
    
        self. publishMVC = [[publishModalVC alloc]init];
        compose.tabBarItem.title = @"发布";
    _publishNav = [[UINavigationController alloc]initWithRootViewController:self.publishMVC];
    
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/5, SCREEN_HEIGHT-48, SCREEN_WIDTH/5, 48)];
        [self.view addSubview:self.maskView];
        self.publishButton = [UIButton new];
        [self.publishButton  setImage:[UIImage imageNamed:@"publishButton.png"] forState:UIControlStateNormal];
        [self.maskView addSubview:self.publishButton];
        [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-15);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(48);
        }];
        [self.publishButton addTarget:self action:@selector(addButtonPressedAndPresentAView) forControlEvents:UIControlEventTouchUpInside];
    
    navigationVC *tabbar_message=[[navigationVC alloc]init];
        messageVC *messagevc = [[messageVC alloc]init];
        [tabbar_message pushViewController:messagevc animated:YES];
        tabbar_message.tabBarItem.title=@"消息";
        tabbar_message.tabBarItem.image=[UIImage imageNamed:@"tabbar_message.png"];
    
    
    profileVC *profilevc = [[profileVC alloc]init];
//        [tabbar_profile pushViewController:profilevc animated:YES];
    navigationVC *tabbar_profile=[[navigationVC alloc]initWithRootViewController:profilevc];
    
        tabbar_profile.tabBarItem.title=@"我的";
        tabbar_profile.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    
    self.viewControllers=@[tabbar_homePage,tabbar_community,compose,tabbar_message,tabbar_profile];
}
-(void)addButtonPressedAndPresentAView{
//    self.maskView.hidden = YES;
//    self.publishButton.hidden = YES;
    [self presentViewController:_publishNav animated:YES completion:^{
        //NSLog(@"receive the notify");
    }];
}
-(void)backButtonPressedAndDisPresentView{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)hidesBarAndItems{
    self.maskView.hidden = YES;
    
}
-(void)presentBarAndItems{
    self.maskView.hidden = NO;
    //self.publishButton.hidden = NO;
}
-(void)createUserGuideV{
    SDCycleScrollView *scrollV = [[SDCycleScrollView alloc]initWithFrame:self.view.bounds];
    scrollV.infiniteLoop = NO;
    scrollV.localizationImageNamesGroup = @[[UIImage imageNamed:@"h1.jpg"],[UIImage imageNamed:@"h2.jpg"],[UIImage imageNamed:@"h3.jpg"],[UIImage imageNamed:@"h4.jpg"]];
    scrollV.autoScroll = NO;
    scrollV.delegate = self;
    scrollV.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.view addSubview:scrollV];
    
     _entryButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT-50, 200, 50)];
    _entryButton.backgroundColor = [UIColor blueColor];
    _entryButton.alpha = 0;
    [scrollV addSubview:_entryButton];
    
}
-(void)cycleScrollViewfinishGuiding:(SDCycleScrollView *)cycleScrollView{
        if (cycleScrollView == _entryButton.superview) {
            
            [UIView animateWithDuration:0.6 animations:^{

                _entryButton.alpha = 1;
                _entryButton.transform = CGAffineTransformMakeTranslation(0, -50);
            }completion:^(BOOL finished) {
                [_entryButton addTarget:self action:@selector(removeTheGuideView:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
       
}
-(void)removeTheGuideView:(UIButton*)entryBt{
    [UIView animateWithDuration:1.5 animations:^{
        entryBt.superview.transform = CGAffineTransformMakeScale(1.5, 1.5);
        entryBt.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [entryBt.superview removeFromSuperview];
        //self.homepageVC.cycleScrollView.autoScroll = YES;
    }];
}

@end

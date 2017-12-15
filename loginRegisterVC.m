//
//  loginRegisterVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "loginRegisterVC.h"
#import "NSString+SHA1HMAC.h"
#import"NSString+SHA1Digest.h"
#import "NetWorkingObj.h"
#import "CoreDateManager.h"
#import <ShareSDK/ShareSDK.h>
#import "qqWechatIcon.h"
#import "loginTextField.h"
@interface loginRegisterVC()<NetWorkingDelegate>{
    loginTextField *username;
    loginTextField *password;
    UITextField *verify;
    UIButton *loginButton;
    UILabel *warningL1;
}
@property UILabel *loginMessage;
@property qqWechatIcon *qqButton;
@property qqWechatIcon *wechatButton;
@property qqWechatIcon *weiboButton;
@end

@implementation loginRegisterVC
-(void)viewDidLoad{
    
    username = [[loginTextField alloc]initWithImage:[UIImage imageNamed:@"userNameIcon"]andTitle:@"账号："];
    password = [[loginTextField alloc]initWithImage:[UIImage imageNamed:@"passwordIcon"]andTitle:@"密码："];
    
    loginButton = [[UIButton alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    username.backgroundColor = [UIColor whiteColor];
    username.layer.cornerRadius = 3;
    username.clipsToBounds = YES;
    username.font = [UIFont systemFontOfSize:13];
    
    password.backgroundColor = [UIColor whiteColor];
    password.layer.cornerRadius = 3;
    password.clipsToBounds = YES;
    password.font = [UIFont systemFontOfSize:13];
    
    loginButton.backgroundColor = [UIColor orangeColor];
    [loginButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 3;
    loginButton.clipsToBounds = YES;
     [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginMessage = [UILabel new];
    [self.view addSubview:username];
    [self.view addSubview:password];
    [self.view addSubview:loginButton];
    //填补空白
    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self initWithButtons];
    warningL1 = [UILabel new];
    [self.view addSubview:warningL1];

}
- (void)initWithButtons{
    _qqButton = [[qqWechatIcon alloc]init];
    _weiboButton = [[qqWechatIcon alloc]init];
    _wechatButton = [[qqWechatIcon alloc]init];
    [_qqButton setImage:[UIImage imageNamed:@"qqIcon.png"] forState:UIControlStateNormal];
    [_wechatButton setImage:[UIImage imageNamed:@"wechatIcon"] forState:UIControlStateNormal];
    [_weiboButton setImage:[UIImage imageNamed:@"weiboIcon.png"] forState:UIControlStateNormal];
    [self.view addSubview:_qqButton];
    [self.view addSubview:_weiboButton];
    [self.view addSubview:_wechatButton];
}
-(void)viewWillAppear:(BOOL)animated{
    switch (self.theUserState) {
        case ZYTUserStateToLogin:
            [self initWithLoginView];
            break;
        case ZYTUserStateToRegister:
            [self initWithRegisterView];
            break;
        default:
            break;
    }
}
-(void)initWithRegisterView{
    self.navigationItem.title = @"一卡通注册";
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    username.placeholder = @"请输入你的手机号码";
    [username mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT+20);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
//    [password mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(username.mas_bottom).offset(20);
//        make.left.mas_equalTo(username.mas_left);
//        make.right.mas_equalTo(username.mas_right);
//        make.height.mas_equalTo(40);
//    }];
    password.placeholder = @"密码";
    [password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(username.mas_bottom).offset(20);
        make.left.mas_equalTo(username.mas_left);
        make.right.mas_equalTo(username.mas_right);
        make.height.mas_equalTo(40);
    }];
    [loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(20);
        make.left.mas_equalTo(username.mas_left);
        make.right.mas_equalTo(username.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    warningL1.hidden = NO;
    warningL1.text = @"免费注册一卡通系统，用户信息已加密";
    warningL1.font = [UIFont systemFontOfSize:12];
    warningL1.textColor  = [UIColor colorWithWhite:0.7 alpha:1];
    [warningL1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [_qqButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(loginButton.mas_bottom).offset(70);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_qqButton addTarget:self action:@selector(loginByQQ) forControlEvents:UIControlEventTouchUpInside];
    
    [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qqButton);
        make.centerX.mas_equalTo(self.view).offset(-90);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qqButton);
        make.centerX.mas_equalTo(self.view).offset(90);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
- (void)loginByQQ{
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
                 if (state == SSDKResponseStateSuccess)
                 {
                     
                     NSLog(@"uid=%@",user.uid);
                     NSLog(@"%@",user.credential);
                     NSLog(@"token=%@",user.credential.token);
                     NSLog(@"nickname=%@",user.nickname);
                 }
                 
                 else
                 {
                     NSLog(@"%@",error);
                 }
                 
             }];
}
-(void)initWithLoginView{
    warningL1.hidden = YES;
    
    self.navigationItem.title = @"一卡通登录";
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    username.placeholder = @"手机号码/卡号";
    [username mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT+20);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    password.placeholder = @"密码";
    password.secureTextEntry = YES;
    [password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(username.mas_bottom).offset(20);
        make.left.mas_equalTo(username.mas_left);
        make.right.mas_equalTo(username.mas_right);
        make.height.mas_equalTo(40);
    }];
    [loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(20);
        make.left.mas_equalTo(username.mas_left);
        make.right.mas_equalTo(username.mas_right);
        make.height.mas_equalTo(40);
    }];
    
//    [_qqButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.equalTo(loginButton.mas_bottom).offset(70);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//    [_qqButton addTarget:self action:@selector(loginByQQ) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_qqButton);
//        make.centerX.mas_equalTo(self.view).offset(-90);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//    [_weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_qqButton);
//        make.centerX.mas_equalTo(self.view).offset(90);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];

    
    
}
-(void)backButtonPressed{
    
}

-(void)loginButtonPressed:(UIButton*)button
{
//    NetWorkingObj *net = [NetWorkingObj shareInstance];
//    net.delegate = self;
//    if(self.theUserState == ZYTUserStateToRegister){
//        [net regiterToServer:username.text andPassword:password.text];
//    }else if(self.theUserState == ZYTUserStateToLogin){
//        [net loginWithPhone:username.text andPassword:password.text];
//    }
    NSLog(@"login");
//    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    username.hidden = YES;
    password.hidden = YES;
    verify = [[UITextField alloc]init];
    verify.backgroundColor = [UIColor whiteColor];
    verify.layer.cornerRadius = 3;
    verify.clipsToBounds = YES;
    verify.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:verify];
    verify.placeholder = @"请输入短信验证码";
    [verify mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT+30);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-100);
        make.height.mas_equalTo(40);
    }];
    UIButton *repost = [[UIButton alloc]init];
    [self.view addSubview:repost];
    [repost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT+30);
        make.left.mas_equalTo(verify.mas_right).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [repost setTitle:@"重新发送" forState:UIControlStateNormal];
    repost.layer.cornerRadius = 3;
    repost.clipsToBounds = YES;
    [repost setTitleColor:Tint_COLOR forState:UIControlStateNormal];
    repost.layer.borderWidth  = 0.5;
    repost.titleLabel.font = [UIFont systemFontOfSize:14];

    [_qqButton removeFromSuperview];
    [_wechatButton removeFromSuperview];
    [_weiboButton removeFromSuperview];
}

- (void)NetWorkingFinishLoginWithStatu:(NSString *)status{
    CoreDateManager *cache = [[CoreDateManager alloc]init];
    UserMdl *currentUser  =  [UserMdl getCurrentUserMdl];
    NSLog(@"%@ !",status);
    _loginMessage.text = status;
    if ([_loginMessage.text isEqualToString:@"登录成功"]) {
        [cache updateUser:[NSMutableArray arrayWithObject:currentUser]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

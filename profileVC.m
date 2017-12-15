//
//  profileVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "profileVC.h"
#import "profileOptionsCell.h"
#import "loginRegisterVC.h"
#import "ProfileDetailVC.h"
#import "UIViewController+notificationForTabbar.h"
#import "CoreDateManager.h"
#import "UserMdl.h"
#import "UIButton+WebCache.h"
#import "NetWorkingObj.h"
#import "adminSettingVC.h"

@interface profileVC ()<NetWorkingDelegate>
@property loginRegisterVC *loginRegistervc;

@property ProfileDetailVC *detailsVC;
@property BOOL isUserAvailable;
@property UIButton *favicon;
@property UILabel *username;
@property UILabel *age;
@property UIImageView *sexIcon;
@property UIImageView *backImageV;
@end
static NSString *cellIndentifier = @"cell";
@implementation profileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.isUserAvailable = NO;
    [self initWithTableView];
    [self initWithLoginAndRegisterViewController];
    
}
-(void)viewDidAppear:(BOOL)animated{
    UserMdl *user = [UserMdl getCurrentUserMdl];
    if (user.userId > 0)
        self.isUserAvailable = YES;
    else self.isUserAvailable = NO;
    [self.tableview reloadData];
    [self presentTabbar];
}
-(void)initWithLoginAndRegisterViewController{
    self.loginRegistervc = [[loginRegisterVC alloc]init];
    self.detailsVC = [[ProfileDetailVC alloc]init];
}
#pragma mark -------------------login and register
-(void)initButtonWithLoginandRegister{
     _loginButton = [UIButton new];
     _registerButton = [UIButton new];
    
     _registerButton.layer.borderWidth = 2;
     _registerButton.layer.cornerRadius = 5.0;
     _registerButton.layer.borderColor = Tint_COLOR.CGColor;
    
     _loginButton.layer.cornerRadius = 5.0;
     _registerButton.clipsToBounds = YES;//剪切到和边框一样.
    [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_registerButton addTarget:self action:@selector(registerButtonPressed:)
             forControlEvents:UIControlEventTouchDown];
   
    [_loginButton setBackgroundColor:Tint_COLOR];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_registerButton setTitleColor:Tint_COLOR forState:UIControlStateNormal];
}

#pragma  mark ------------------tableView
-(void)initWithTableView{
    self.itemsText = [NSArray arrayWithObjects:@"我的帮助",@"我的需求",@"我赞过的",@"我的钱包",@"抵用劵",@"联系客服",nil];
    self.flagImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"我的帮助.png"],[UIImage imageNamed:@"我的需求.png"],[UIImage imageNamed:@"我赞过的.png"],[UIImage imageNamed:@"我的钱包.png"],[UIImage imageNamed:@"抵用劵.png"],[UIImage imageNamed:@"联系客服.png"],nil];
    self.tableview = [[UITableView alloc]init];
    self.tableview.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //[self.tableview.tableFooterView setBackgroundColor:[UIColor colorWithWhite:0.94 alpha:0]];

    [self.tableview registerClass:[profileOptionsCell class] forCellReuseIdentifier:cellIndentifier];
}
-(void)createUserBackgroundAndFavicon:(UIView*)view{
    UserMdl *user = [UserMdl getCurrentUserMdl];
    if (self.favicon==nil) {
        self.favicon = [UIButton new];
        [_favicon setImageWithURL:[NSURL URLWithString:user.faviconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"favicon"]];
        [view addSubview:self.favicon];
    }
         self.favicon.layer.cornerRadius = 24;
        _favicon.clipsToBounds = YES;
        [self.favicon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(padding);
//          make.bottom.equalTo(view).offset(-padding);
            make.height.mas_equalTo(46);
            make.centerY.mas_equalTo(view);
            make.width.equalTo(self.favicon.mas_height);
            
        }];
    
    
    if (self.username == nil) {
        self.username = [UILabel new];
        [view addSubview:self.username];
    }
        self.username.text = user.nickName;
        [self.username mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.favicon.mas_right).offset(padding);
            make.bottom.equalTo(self.favicon.mas_centerY);
        }];
    
    
    if (self.sexIcon == nil) {
        self.sexIcon = [UIImageView new];
        
        [view addSubview:self.sexIcon];
    }
    self.sexIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)user.sex]];
    [self.sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.username);
        make.top.equalTo(self.favicon.mas_centerY);
        make.size.mas_equalTo(15);
    }];

   
    if (!self.age) {
        self.age = [UILabel new];
        self.age.textColor = [UIColor grayColor];
        self.age.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.age];
    }
    self.age.text = [NSString stringWithFormat:@"%ld岁",(long)user.age];
    [self.age mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexIcon.mas_right).offset(padding);
        make.top.equalTo(self.favicon.mas_centerY);
    }];
}
-(void)CleanSection:(BOOL)status{
    [self.favicon removeFromSuperview];
    self.favicon = nil;
    [_loginButton removeFromSuperview];
    [_registerButton removeFromSuperview];
}
#pragma mark -----------------------tableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    profileOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        //cell.exclusiveTouch  = YES;
//        if (self.loginRegistervc.theUserState == ZYTUserStateToLogin || self.loginRegistervc.theUserState == ZYTUserStateToRegister) {
            //tableView.allowsSelection = NO;
//            cell.userInteractionEnabled = NO;
        //}
        //UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"section1.png"]];
        //[cell setBackgroundView:imageV];
        [self CleanSection:YES];
        if (!self.isUserAvailable) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self initButtonWithLoginandRegister];
            [cell.contentView addSubview:_loginButton];
            [cell.contentView addSubview:_registerButton];
            [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_centerX).offset(-10);
                make.width.mas_equalTo(90);
                make.height.mas_equalTo(30);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_centerX).offset(10);
                make.width.mas_equalTo(_registerButton.mas_width);
                make.height.mas_equalTo(_registerButton.mas_height);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        else
            [self createUserBackgroundAndFavicon:cell.contentView];
    }
    else if(indexPath.section ==1){
        [cell createLabelWithText:self.itemsText[indexPath.row]];
        [cell createImageFlag:self.flagImages[indexPath.row]];
    }
    else if(indexPath.section ==2){
        [cell createLabelWithText:@"系统设置"];
        [cell createImageFlag:[UIImage imageNamed:@"系统设置.png"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        self.detailsVC.tag = OPTIONTAGINFO;
        if (_isUserAvailable) {
            adminSettingVC *adminsetting = [[adminSettingVC alloc]init];
            [self.navigationController pushViewController:adminsetting animated:YES];
            [self hideTheTabbar];
        }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                self.detailsVC.tag = OPTIONTAGHELP;
                break;
            case 1:
                self.detailsVC.tag = OPTIONTAGNEEDS;
                break;
            case 2:
                self.detailsVC.tag = OPTIONTAGPRAISE;
                break;
            case 3:{
                self.detailsVC.tag = OPTIONTAGWALLET;
            }
                break;
            case 4:{
                self.detailsVC .tag = OPTIONTAGVOUCHER;
                NetWorkingObj *networking = [NetWorkingObj shareInstance];
                [networking getMyHelpOrder:1];
                networking.delegate = self.detailsVC;

            }
                break;
            case 5:
                self.detailsVC.tag = OPTIONTAGCONNET;
                break;
            default:
                break;
        }
         [self.navigationController pushViewController:self.detailsVC animated:YES];
         [self hideTheTabbar];
    }
    else {
        self.detailsVC.tag = OPTIONTAGSETTING;
        [self.navigationController pushViewController:self.detailsVC animated:YES];
         [self hideTheTabbar];
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {view.tintColor = [UIColor clearColor];}

#pragma mark ----------------------show different details View
-(void)showProfileDetailView{
    [self.navigationController pushViewController:self.detailsVC animated:YES];
}

#pragma mark ----------------------buttonDelegate
-(void)loginButtonPressed:(id)sender{
    self.loginRegistervc.theUserState = ZYTUserStateToLogin;
    [self.navigationController pushViewController:self.loginRegistervc animated:YES];
    [self hideTheTabbar];
}
-(void)registerButtonPressed:(id)sender{
    self.loginRegistervc.theUserState = ZYTUserStateToRegister;
    [self.navigationController pushViewController:self.loginRegistervc animated:YES];
    [self hideTheTabbar];
}
@end

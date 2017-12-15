//
//  ProfileDetailVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/27.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "ProfileDetailVC.h"
#import "universalCell.h"
#import "voucherCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UITableViewCell+commonCELL.h"
#import "settingVC.h"
#import "addressSetVC.h"
#import "detailVC.h"
#import "NetWorkingObj.h"
#import "receiveMdl.h"
#import "loginRegisterVC.h"
#import "walletCell2.h"
#import "messageTableViewCell.h"

@class profile_option_model;
@class NetWorkingObj;

@interface ProfileDetailVC()<UITableViewDataSource,UITableViewDelegate,NetWorkingDelegate>
@property UITableView *infoTableView;
@property UIView *backView;
@property addressSetVC *addressvc;
@property settingVC *setvc;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@property NSMutableArray *helpList;
@property NSMutableArray *needsList;
@property NSMutableArray *praisedList;
@property NSMutableArray *vouchersList;

@property UIButton *logoutBt;
@end
static NSString *commonCellIdentifier = @"common";
static NSString *customeCellIdentifier = @"custome";
static NSString *voucherCellIdentifier = @"voucher";
static NSString *walletCellIdentifier2 = @"wallet2";
static NSString *messageStyleCellId = @"messageCell";

@implementation ProfileDetailVC
-(void)viewDidLoad{
    [super viewDidLoad];
    self.infoTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    self.infoTableView.delegate =self;
    self.infoTableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    self.infoTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.infoTableView];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5625)];
    self.infoTableView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    //去掉下面的tabbar
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    //self.navigationController.navigationBar.maskView
    //[[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    _addressvc = [[addressSetVC alloc]init];
    _setvc = [[settingVC alloc]init];
    
    [self createLogoutButton];

}
-(void)viewWillAppear:(BOOL)animated{
    
    profile_option_model *model = [[profile_option_model alloc]init];
    switch (self.tag) {
        case OPTIONTAGINFO:
            break;
        case OPTIONTAGHELP:
            [self initWithMyHelp:model];
            break;
        case  OPTIONTAGNEEDS:
            [self initWithMyNeeds:model];
            break;
        case OPTIONTAGPRAISE:
            [self initWithMyPraised:model];
            break;
        case OPTIONTAGWALLET:
            [self initWithMyWallet:model];
            break;
        case OPTIONTAGVOUCHER:
            [self initWithMyVoucher:model];
            break;
        case OPTIONTAGCONNET:
            [self initWithConnet:model];
            break;
            
        case OPTIONTAGSETTING:
            [self initWithSetting:model];
            break;
        default:
            break;
    }
    _infoTableView.scrollEnabled = YES;
    [self.infoTableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    _logoutBt.hidden = YES;
    //self.navigationController.navigationBarHidden = NO;
}
- (void)createLogoutButton{
    _logoutBt = [UIButton new];
    [self.view addSubview:_logoutBt];
    [_logoutBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(13);
        make.rightMargin.mas_equalTo(-13);
        make.bottomMargin.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    _logoutBt.layer.cornerRadius = 3;
    _logoutBt.layer.backgroundColor = Tint_COLOR.CGColor;
    [_logoutBt setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutBt addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _logoutBt.hidden = YES;
}
-(void)initWithMyInfo:(profile_option_model*)model{
   
    self.infoTableView . tableHeaderView = _backView;
    
}
-(void)initWithMyHelp:(profile_option_model*)model{
    self.navigationItem.title = @"我的帮助";
    [self.infoTableView registerClass:[universalCell class] forCellReuseIdentifier:customeCellIdentifier];
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.infoTableView.clipsToBounds = NO;
    //预设高度
     self.infoTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self tableViewWithMarginStyle];
    
    //[self tableViewWithMarginStyle];
    
    
}
-(void)initWithMyNeeds:(profile_option_model*)model{
    self.navigationItem.title = @"我的需求";
    [self.infoTableView registerClass:[universalCell class] forCellReuseIdentifier:customeCellIdentifier];
    self.infoTableView.clipsToBounds = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NetWorkingObj *networking = [NetWorkingObj shareInstance];
    [networking getMyNeedsOrder:1];
    networking.delegate = self;
    [self tableViewWithMarginStyle];

}
-(void)initWithMyPraised:(profile_option_model*)model{
    self.navigationItem.title = @"我赞过的";
    [self.infoTableView registerClass:[universalCell class] forCellReuseIdentifier:customeCellIdentifier];
    self.infoTableView.clipsToBounds = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NetWorkingObj *networking = [NetWorkingObj shareInstance];
    [networking getMyPraisedOrder:3];
    networking.delegate = self;
    [self tableViewWithMarginStyle];
}
-(void)initWithMyWallet:(profile_option_model*)model{
    self.navigationItem.title = @"闲么钱包";
    _infoTableView.scrollEnabled = NO;
    [_infoTableView registerClass:[walletCell2 class] forCellReuseIdentifier:walletCellIdentifier2];
    [_infoTableView registerClass:[messageTableViewCell class] forCellReuseIdentifier:messageStyleCellId];
    [self tableViewWithNoMarginStyle];
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

}
-(void)initWithMyVoucher:(profile_option_model*)model{
    self.navigationItem.title = @"抵用劵";
    [self.infoTableView registerClass:[voucherCell class] forCellReuseIdentifier:voucherCellIdentifier];
    //self.infoTableView.clipsToBounds = NO;
    //预设高度
    self.infoTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self tableViewWithMarginStyle];
    [_infoTableView setTableFooterView:[UIView new]];
    
    NetWorkingObj *network = [NetWorkingObj shareInstance];
    [network getVoucher];
    network.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openTheVoucher) name:@"openVoucher" object:nil];
}
-(void)initWithConnet:(profile_option_model*)model{
    self.navigationItem.title = @"联系客服";
    UIView *whiteView = [[UIView alloc]init];
    //whiteView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self.infoTableView setTableFooterView:whiteView];
    [self tableViewWithNoMarginStyle];
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}
-(void)initWithSetting:(profile_option_model*)model{
    _logoutBt.hidden = NO;
    [self tableViewWithNoMarginStyle];
    self.navigationItem.title = @"系统设置";
    [self.infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:customeCellIdentifier];
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
}

- (void)logoutButtonPressed{
    loginRegisterVC *logvc = [[loginRegisterVC alloc]init];
    [self.navigationController pushViewController:logvc animated:YES];
}

#pragma mark -------------------------------networking delegate
- (void)NetWorkingFinishedWithNeeds:(NSArray *)list{
    _needsList = [NSMutableArray array];
    for (NSMutableDictionary *dic in list) {
        orderMdl *order = [orderMdl initFromDictionary:dic];
        [_needsList addObject:order];
    }
    [self.infoTableView reloadData];
}
- (void)NetWorkingFinishedWithPraised:(NSArray *)list{
    _praisedList = [NSMutableArray array];
    for (NSMutableDictionary *dic in list) {
        orderMdl *order = [orderMdl initFromDictionary:dic];
        [_praisedList addObject:order];
    }
    [_infoTableView reloadData];
}

- (void)NetWorkingFailedWithMyHelped:(NSArray *)list{
    _helpList = [NSMutableArray array];
    for (NSMutableDictionary *dic in list) {
        receiveMdl *receive = [receiveMdl initFromDictionary:dic];
        [_helpList addObject:receive];
    }
    [_infoTableView reloadData];
}

- (void)NetWorkingFinishGotVoucher:(NSArray *)vouchers{
    _vouchersList = [NSMutableArray arrayWithArray:vouchers];
    [_infoTableView reloadData];
}

#pragma mark ----------------------------------tableView style
-(void)tableViewWithNoMarginStyle{
    [self.infoTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.equalTo(self.view);
    }];
}
-(void)tableViewWithMarginStyle{
    [self.infoTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


#pragma mark  ===========open voucher   notify
- (void)openTheVoucher{
    [_infoTableView reloadData];
}


#pragma  mark -------------------------tableview Delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *commonCell  = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier];
    universalCell *customeCell = [tableView dequeueReusableCellWithIdentifier:customeCellIdentifier];
    voucherCell *vouchercell = [tableView dequeueReusableCellWithIdentifier:voucherCellIdentifier];
    walletCell2 *walletCell = [tableView dequeueReusableCellWithIdentifier:walletCellIdentifier2];
    messageTableViewCell *messagecell = [tableView dequeueReusableCellWithIdentifier:messageStyleCellId];
   
    if (commonCell == nil) {
          commonCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commonCellIdentifier];
    }
    commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    customeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (self.tag) {
        case OPTIONTAGINFO:
             return NULL;
            break;
        case OPTIONTAGHELP:
        {
            receiveMdl *receive = _helpList[indexPath.section];
            [customeCell configureCellWithModel:receive.o_order];
            [customeCell.grabOrder setTitle:@"已完成" forState:UIControlStateNormal];
            [customeCell addTheGrabOrder:^{
                
            }];
            [customeCell setNeedsUpdateConstraints];
            [customeCell updateConstraintsIfNeeded];
            return customeCell;
        }
            break;
        case  OPTIONTAGNEEDS:
        {
            receiveMdl *receive = _needsList[indexPath.section];
            [customeCell configureCellWithModel:receive.o_order];            return customeCell;
        }
            break;
        case OPTIONTAGPRAISE:{
            receiveMdl *receive = _praisedList[indexPath.section];
            [customeCell configureCellWithModel:receive.o_order];
        }
            return customeCell;
            break;
        case OPTIONTAGWALLET:
            [commonCell clearTheItems];
            
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            commonCell.textLabel.font = [UIFont systemFontOfSize:12];
            commonCell.textLabel.textColor = Font_COLOR;
            commonCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            commonCell.detailTextLabel.textColor = [UIColor grayColor];
             commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.section == 0) {
                
                if (indexPath.row == 0) {
                    messagecell.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
                    [messagecell updateWithIcon:[UIImage imageNamed:@"wallet_icon.png"] AndTitle:@"余额" AndDetailInfo:@"50.00" and:YES];
                    messagecell.label.font = [UIFont systemFontOfSize:12];
                    messagecell.label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                    messagecell.detailInfoLb.font = [UIFont systemFontOfSize:17];
                    messagecell.detailInfoLb.textColor = [UIColor whiteColor];
                    
                    [messagecell.detailInfoLb mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(messagecell.label.mas_bottom).offset(2);
                    }];
                    return messagecell;
                }
                else{
                    return walletCell;
                }
            }
            else{
                if (indexPath.row == 0) {
                    commonCell.textLabel.text = @"我的银行卡";
                }
                else{
                    commonCell.textLabel.text = @"支付管理";
                    commonCell.detailTextLabel.text = @"设置支付密码";
                }
                
            }
            return commonCell;
            break;
        case OPTIONTAGVOUCHER:{
            [vouchercell updateTheData:_vouchersList[indexPath.section]];
        }
             return vouchercell;
            break;
        case OPTIONTAGCONNET:
            //清空颜色
            [commonCell clearTheItems];
           

            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            commonCell.textLabel.font = [UIFont systemFontOfSize:12];
            commonCell.textLabel.textColor = [UIColor grayColor];
            commonCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            commonCell.detailTextLabel.textColor = [UIColor grayColor];
            if (indexPath.section == 0) {
                commonCell.textLabel.text = @"帮助中心";
            }
            else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    commonCell.textLabel.text = @"在线客服";
                }
                else {commonCell.textLabel.text = @"客服热线";
                    commonCell.detailTextLabel.text = @"400-955-796";
                }
            }
            else commonCell.textLabel.text = @"意见反馈";
            return commonCell;
            break;
            
        case OPTIONTAGSETTING:
            [commonCell clearTheItems];
            
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            commonCell.textLabel.font = [UIFont systemFontOfSize:12];
            commonCell.textLabel.textColor = [UIColor grayColor];
            commonCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
             commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.section==0) {
               
                commonCell.textLabel.text = @"个人资料设置";
            }
            else if (indexPath.section==1){
                switch (indexPath.row) {
                    case 0:
                        commonCell.textLabel.text = @"常用地址";
                        break;
                    case 1:
                        commonCell.textLabel.text = @"绑定账号";
                        break;
                    case 2:{
                        commonCell.textLabel.text = @"推送通知";
                        commonCell.accessoryType = UITableViewCellAccessoryNone;
                        UISwitch *theswitch = [UISwitch new];
                        theswitch.onTintColor = Tint_COLOR;
                        [commonCell.contentView addSubview:theswitch];
                        [theswitch mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(commonCell.contentView).offset(-15);
                            make.centerY.equalTo(commonCell.contentView);
                        }];
                    }
                        break;
                    case 3:{
                        commonCell.textLabel.text = @"开启听筒模式";
                        commonCell.accessoryType = UITableViewCellAccessoryNone;
                        UISwitch *theswitch = [UISwitch new];
                        theswitch.onTintColor = Tint_COLOR;
                        [commonCell.contentView addSubview:theswitch];
                        [theswitch mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(commonCell.contentView).offset(-15);
                            make.centerY.equalTo(commonCell.contentView);
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }
            else
                commonCell.textLabel.text  = @"关于闲么";
            
            return commonCell;
            break;
        default:
            return NULL;
            break;
    }
}
//多少row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.tag) {
        case OPTIONTAGINFO:
            return 0;
            break;
        case OPTIONTAGHELP:
            return 1;
            break;
        case  OPTIONTAGNEEDS:
            return 1;
            break;
        case OPTIONTAGPRAISE:
            return 0;
            break;
        case OPTIONTAGWALLET:
            switch (section) {
                case 0:
                    return 2;
                    break;
                case 1:
                    return 2;
                default:
                    return 0;
                    break;
            }
            break;
        case OPTIONTAGVOUCHER:
            return 1;
            break;
        case OPTIONTAGCONNET:
            switch (section) {
                case 0:
                    return  1;
                    break;
                case 1:
                    return 2;
                    break;
                case 2:
                    return 1;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case OPTIONTAGSETTING:
            switch (section) {
                case 0:
                    return  1;
                    break;
                case 1:
                    return 4;
                    break;
                case 2:
                    return 1;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
    }
}
//多少section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.tag) {
        case OPTIONTAGINFO:
            return 0;
            break;
        case OPTIONTAGHELP:
            return _helpList.count;
            break;
        case  OPTIONTAGNEEDS:
            return _needsList.count;
            break;
        case OPTIONTAGPRAISE:
            return _praisedList.count;
            break;
        case OPTIONTAGWALLET:
            return 2;
            break;
        case OPTIONTAGVOUCHER:
            return _vouchersList.count;
            break;
        case OPTIONTAGCONNET:
            return 3;
            break;
        case OPTIONTAGSETTING:
            return 3;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {view.tintColor = [UIColor clearColor];}
//cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag == OPTIONTAGHELP) {
        return [self.infoTableView fd_heightForCellWithIdentifier:customeCellIdentifier cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
            receiveMdl *receive = _helpList[indexPath.section];
            [cell configureCellWithModel:receive.o_order];
        }];
    }
    else if (_tag == OPTIONTAGNEEDS){
        return [self.infoTableView fd_heightForCellWithIdentifier:customeCellIdentifier cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
            [cell configureCellWithModel:_needsList[indexPath.section]];
        }];
    }else if (_tag == OPTIONTAGPRAISE)
        return [tableView fd_heightForCellWithIdentifier:customeCellIdentifier cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
            [cell configureCellWithModel:_praisedList[indexPath.section]];
        }];
    if (self.tag == OPTIONTAGVOUCHER) {
        return [self.infoTableView fd_heightForCellWithIdentifier:voucherCellIdentifier cacheByIndexPath:indexPath configuration:^(voucherCell *cell) {
            [cell updateTheData:_vouchersList[indexPath.row]];
        }];
    }
    return tableView.rowHeight;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.tag) {
        case OPTIONTAGINFO:{
            
        }
            break;
        case OPTIONTAGHELP:{
            detailVC *detailvc = [[detailVC alloc]init];
            detailvc.type = DETAILTYPECELL;
            detailvc.model = _helpList[indexPath.section];
            [self.navigationController pushViewController:detailvc animated:YES];
        }
            
            break;
        case  OPTIONTAGNEEDS:
            
            break;
        case OPTIONTAGPRAISE:
           
            break;
        case OPTIONTAGWALLET:
            break;
        case OPTIONTAGVOUCHER:
            
            break;
        case OPTIONTAGCONNET:
            
            break;
        case OPTIONTAGSETTING:{
            if (indexPath.section ==0) {
                [self.navigationController pushViewController:_setvc animated:YES];
            }else if (indexPath.section ==1){
                if (indexPath.row==0) {
                   [self.navigationController pushViewController:_addressvc animated:YES];
                }else if (indexPath.row ==1){
                    
                }else{//开关
                    
                }
            }else{//关于闲么
                
            }
        }
            break;
    }
}
@end

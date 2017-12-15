//
//  adminInfoVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/30.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "adminInfoVC.h"
#import "universalCell.h"
#import "UserMdl.h"
#import "NetWorkingObj.h"
#import "NSString+timeFormat.h"
#import "UIButton+WebCache.h"
#define White    [UIColor whiteColor]


static NSString *cellIndentifier = @"cellId";
@interface adminInfoVC ()<UITableViewDataSource,UITableViewDelegate,NetWorkingDelegate>
@property UITableView *tableView;
@property UIImageView *infoBGImageV;
@property UIButton *favicon;
@property UIView *praisefaviconsV;
@property UILabel *praiseNum;

@property UILabel *username;
@property UILabel *age;
@property UIImageView *sexual;
@property UILabel *signature;
@property NSMutableArray *orderList;
@end

@implementation adminInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =  V_COLOR;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self initialTableView];
    [self initialInfoBGImageV];
    //[self initialTheBackItem];
    [self initialWithFavicon];
    [self initialPraisedV];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarBG.png"] forBarMetrics:UIBarMetricsCompact];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
//    NSLog(@"%f",NAV_HEIGHT);
    [self loadDatas];
}
- (void)loadDatas{
    UserMdl *theUser = [UserMdl getCurrentUserMdl];
    
    [_favicon setImageWithURL:[NSURL URLWithString:theUser.faviconUrl ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"favicon"]];
    self.username.text = theUser.nickName;
    self.age.text = [NSString stringWithFormat:@"%ld",(long)theUser.age];
    _sexual.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)theUser.sex]];
    self.praiseNum.text   =  [NSString stringWithFormat:@"收到的赞%d次",0];
    
    
    NetWorkingObj *net = [NetWorkingObj shareInstance];
    [net getTheUnconfirmedOrder:1];
    net.delegate = self;
}

- (void)NetWorkingFinishedWithUnconfirmedOrder:(NSArray *)list{
    _orderList = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        orderMdl *order = [orderMdl initFromDictionary:dic];
        [_orderList addObject:order];
    }
    [_tableView reloadData];
}

//-(void)initialTheBackItem{
//
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 15, 15)];
//
//    [backButton setImage:[UIImage imageNamed:@"backBarItem2.png"]forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backToHomepage) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    
//    
//    self.navigationItem.leftBarButtonItem = backItem;
//}
//-(void)backToHomepage{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)initialWithFavicon{
    self.favicon   =   [UIButton new];
    self.favicon.backgroundColor  =   [UIColor grayColor];
    self.favicon.contentMode = UIViewContentModeScaleToFill;
    _favicon.layer.cornerRadius = 38;
    _favicon.clipsToBounds = YES;
    [self.infoBGImageV addSubview:self.favicon];
    [self.favicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoBGImageV).offset(padding+5);
        make.top.mas_equalTo(self.infoBGImageV).offset(54);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    self.favicon.layer.cornerRadius  =  38;
    
    self.username   =   [UILabel new];
    self.username.text   =   @"未登录";
    self.username.textColor  =  White;
    [self.view addSubview:self.username];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.favicon.mas_right).offset(20);
        make.top.mas_equalTo(self.favicon).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    self.sexual  =   [[UIImageView alloc]init];
    [self.view addSubview:self.sexual];
    [self.sexual mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.username);
        make.width.and.height.mas_equalTo(15);
        make.top.mas_equalTo(self.username.mas_bottom).offset(8);
    }];
    
    self.age   =   [UILabel new];
    self.age.text  =  @"0";
    self.age.textColor   =  White;
    [self.view addSubview:self.age];
    [self.age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.username.mas_bottom).offset(8);
        make.left.mas_equalTo(self.sexual.mas_right).offset(8);
        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(20);
        
    }];
    
    
    self.signature  =   [UILabel new];
    self.signature.textColor  =  White;
    self.signature.text = @"没有留下任何文字";
    self.signature.font  =  [UIFont systemFontOfSize:12];
    [self.view addSubview:self.signature];
    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.username);
        make.top.mas_equalTo(self.age.mas_bottom).offset(8);
    }];
}
-(void)initialPraisedV{
    self.praisefaviconsV  =  [UIView new];
    [self.infoBGImageV addSubview:self.praisefaviconsV ];
    [self.praisefaviconsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.width.equalTo(self.infoBGImageV);
        make.height.mas_equalTo(25);
    }];
    self.praisefaviconsV.backgroundColor   =    [UIColor colorWithWhite:0.2 alpha:0.7];
    
    self.praiseNum   =   [UILabel new];
    [self.praisefaviconsV addSubview:self.praiseNum];
    self.praiseNum.textColor  =  White;
    self.praiseNum.font    =   [UIFont systemFontOfSize:10];
//    self.praiseNum.text   =    @"收到的赞0次";
    [self.praiseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.praisefaviconsV).offset(padding);
        make.centerY.mas_equalTo(self.praisefaviconsV);
        make.height.mas_equalTo(self.praisefaviconsV);
    }];
}

-(void)initialInfoBGImageV{
    self.infoBGImageV = [[UIImageView alloc]init];
    self.infoBGImageV.image   =  [UIImage imageNamed:@"section1.png"];
    [self.tableView addSubview:self.infoBGImageV];
    [self.infoBGImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-padding);
        make.height.mas_equalTo(180);
        make.width.mas_equalTo(self.view.mas_width);
    }];
}
-(void)initialTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(180+padding-(NAV_HEIGHT), 0, 0, 0);
    self.tableView .backgroundColor = V_COLOR;
    [self.tableView registerClass:[universalCell class] forCellReuseIdentifier:cellIndentifier];
    self.tableView.clipsToBounds = NO;
    
    //预设高度
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
   
}


#pragma mark ------------------------------------tablevieDelegate
//这里始终是1
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (tableView == self.tableView) {
        return 1;
//    }else{
//        return self.searchResults.count;
//    }
}
//section数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (tableView == self.tableView){
//        return 3;//自定义这个数
//    }else{
//        return 1;
//    }
    return _orderList.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//设置footerview高度
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {view.tintColor = [UIColor clearColor];}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self.tableView fd_heightForCellWithIdentifier:cellIndentifier cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
        [cell configureCellWithModel:_orderList[indexPath.section]];
    }];
  
}
//datasourse
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    universalCell *mainbodyCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    mainbodyCell.userInteractionEnabled = NO;
    
    orderMdl *ordermodel = self.orderList[indexPath.section];
    ordermodel.createtimeBynow = [NSString compareCurrentTime:ordermodel.createtime];
    [mainbodyCell updateWithModel:ordermodel];
    return  mainbodyCell ;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

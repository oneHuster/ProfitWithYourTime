//
//  communityVC.m
//  闲么
//
//  Created by 邹应天 on 16/2/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "communityVC.h"
#import "universalCell.h"
#import "optionCell.h"
#import "headButton.h"
@interface communityVC()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property UIView *headV;
@property headButton *neighbouring;
@property headButton *hotStateBt ;
@property headButton *marketBt;
@property headButton *guessYouLikeBt;
@end
static NSString *optionCellIndentifier = @"option";
static NSString *universalCellID = @"universal";
@implementation communityVC
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"圈子";
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self creatTableView];
}
-(void)creatTableView{
    self.tableView = [UITableView new];
       //self.tableView.tableHeaderView = self.headV;
    self.tableView.contentInset = UIEdgeInsetsMake(70+25, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView .backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[universalCell class] forCellReuseIdentifier:universalCellID];
    self.tableView.clipsToBounds = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //    //预设高度
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[optionCell class] forCellReuseIdentifier:optionCellIndentifier];
    [self.tableView registerClass:[universalCell class] forCellReuseIdentifier:universalCellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self createHeadView];

}
-(void)createHeadView{
    self.headV = [UIView new];
    [self.tableView addSubview:self.headV];
    
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-25);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(self.view.mas_width);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    self.headV.backgroundColor = [UIColor whiteColor];
    
    UILabel *recommendLabel = [[UILabel alloc]init];
        recommendLabel.backgroundColor = [UIColor clearColor];
        recommendLabel.text = @"推荐圈子";
        recommendLabel.font = [UIFont systemFontOfSize:14];
        recommendLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        [self.tableView addSubview:recommendLabel];
        [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headV.mas_bottom).offset(2.5);
            make.left.mas_equalTo(self.tableView);
        }];
    
    
    //UIButton *neighbouring = [UIButton new];
    
    _neighbouring = [[headButton alloc]initWithImage:[UIImage imageNamed:@"recommend.png"] andTitle:@"附近人说" ];
    //neighbouring.tag = 1;
    [self.headV addSubview:_neighbouring];
    [_neighbouring mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.top.equalTo(self.headV);
        make.width.mas_equalTo(VC_WIDTH/4);
    }];
    [_neighbouring addTarget:self action:@selector(selectTheNeighbouring:) forControlEvents:UIControlEventTouchDown];
    
    
    _hotStateBt = [[headButton alloc]initWithImage:[UIImage imageNamed:@"hotState.png"] andTitle:@"最热状态"];
    [self.headV addSubview:_hotStateBt];
    [_hotStateBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.equalTo(self.headV);
        make.left.equalTo(_neighbouring.mas_right);
        make.width.equalTo(_neighbouring);
    }];
    [_hotStateBt addTarget:self action:@selector(selectTheNeighbouring:) forControlEvents:UIControlEventTouchDown];

    
    self.marketBt = [[headButton alloc]initWithImage:[UIImage imageNamed:@"market.png"] andTitle:@"商场新品"];
    [self.headV addSubview:self.marketBt];
    [self.marketBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.equalTo(self.headV);
        make.left.equalTo(_hotStateBt.mas_right);
        make.width.equalTo(_neighbouring);
    }];
    [self.marketBt addTarget:self action:@selector(selectTheNeighbouring:) forControlEvents:UIControlEventTouchDown];

    
    self.guessYouLikeBt = [[headButton alloc]initWithImage:[UIImage imageNamed:@"guessYouLike.png"] andTitle:@"猜你喜欢"];
    [self.headV addSubview:self.guessYouLikeBt];
    [self.guessYouLikeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.equalTo(self.headV);
        //make.left.equalTo(_hotStateBt.mas_right);
        make.right.mas_equalTo(self.headV);
        make.width.equalTo(_neighbouring);
    }];
    [self.guessYouLikeBt addTarget:self action:@selector(selectTheNeighbouring:) forControlEvents:UIControlEventTouchDown];

    
}
-(void)selectTheNeighbouring:(headButton*)button{
    for (headButton *subButton in self.headV.subviews) {
        subButton.label.textColor = [UIColor grayColor];
    }
    button.label.textColor = Tint_COLOR;
    //button.label.textColor = [UIColor redColor];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        optionCell *optioncell = [tableView dequeueReusableCellWithIdentifier:optionCellIndentifier];
        [optioncell createWithModels];
        return optioncell;
    }
    else {
            universalCell *universalCell = [tableView dequeueReusableCellWithIdentifier:universalCellID];
            return universalCell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else
        return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    else{
        return [tableView fd_heightForCellWithIdentifier:universalCellID cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
            
        }];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 20;
//    }
//    else
//        return  0;
//}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {view.tintColor = [UIColor clearColor];}

@end

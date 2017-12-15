//
//  payVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
typedef NS_ENUM(NSInteger, PAYWAY) {
    PAYWAYNone,//默认从0开始
    PAYWAYWechat,
    PAYWAYZhifubao
};

#import "payVC.h"
#import "payTableViewCell.h"
#import "payIconCell.h"
#import "AlipayHeader.h"
#import "voucherVC.h"

#define selected [UIImage imageNamed:@"selected"]
#define unselected [UIImage imageNamed:@"selectorEllipe"]
@interface payVC()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *tableview;
@property NSArray *itemList;
@property PAYWAY wayToPay;
@property UIButton *wechatBt;
@property UIButton *zhifubaoBt;
@end

static NSString *cellIdentifier = @"payCellId";
static NSString *cellId2 = @"payIconCellId";
@implementation payVC

- (void)viewDidLoad{
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    self.navigationItem.title = @"支付";
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableview registerClass:[payTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tableview registerClass:[payIconCell class] forCellReuseIdentifier:cellId2];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    //[_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    _itemList = @[@"消费",@"卡上余额",@"付后结余"];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self createGrabButton];
}
- (void)createGrabButton{
    UIButton *but = [UIButton new];
    but.layer.backgroundColor = Tint_COLOR.CGColor;
    but.layer.cornerRadius = 3;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.view addSubview:but];
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(padding);
        make.rightMargin.mas_equalTo(-padding);
        //make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-padding);
        make.height.mas_equalTo(40);
    }];
    [but addTarget:self action:@selector(payTheOrder) forControlEvents:UIControlEventTouchUpInside];
   
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    payTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    payIconCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section<1) {
        cell.textLabel.text = _itemList [indexPath.section*3+indexPath.row];
    
//        if (indexPath.row<2) {
            if (indexPath.row == 0)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld元",(long)_money];
            else if(indexPath.row == 1)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld元",(long)_tip];
            
//        }else if(indexPath.section<2){
            else{
                cell.detailTextLabel.textColor = Tint_COLOR;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%ld",_tip+_money];
            }
            
//        }
//        if (indexPath.section == 1&&indexPath.row == 0){
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.detailTextLabel.text = @"使用抵用劵";
//        }
        
        return cell;
    }else{
        cell2.selectBt.tag = indexPath.row+1;
        if (cell2.selectBt.tag%2==0)
            _wechatBt = cell2.selectBt;
        else _zhifubaoBt = cell2.selectBt;
        [cell2.selectBt setImage:unselected forState:UIControlStateNormal];
        [cell2.selectBt addTarget:self action:@selector(selectTheWayToPay:) forControlEvents:UIControlEventTouchDown];
        if (indexPath.row == 0) {
            cell2.textLabel.text = @"微信支付";
            cell2.detailTextLabel.text = @"推荐安装微信5.0以及以上版本的使用";
            cell2.imageView.image = [UIImage imageNamed:@"wechatpay"];
        }else{
            cell2.textLabel.text = @"支付宝支付";
            cell2.detailTextLabel.text = @"推荐有支付宝账号的用户使用";
            cell2.imageView.image = [UIImage imageNamed:@"zhifubao"];
        }
        return cell2;
    }
}

- (void)selectTheWayToPay:(UIButton *)button{
    if (button.tag%2==0){
        [_wechatBt setImage:selected forState:UIControlStateNormal];
        [_zhifubaoBt setImage:unselected forState:UIControlStateNormal];
        _wayToPay = PAYWAYZhifubao;
    }
    else {
        [_wechatBt setImage:unselected forState:UIControlStateNormal];
        [_zhifubaoBt setImage:selected forState:UIControlStateNormal];
        _wayToPay = PAYWAYWechat;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VC_WIDTH, 5)];
    footView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    return footView;
}

- (void)payTheOrder{
    if (_wayToPay == PAYWAYZhifubao)
        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:_orderId productName:@"一卡通" productDescription:@"交易" amount:[NSString stringWithFormat:@"%ld",_tip+_money]notifyURL:@"http://www.xxx.com" itBPay:@"30m"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0&&indexPath.section ==1) {
        voucherVC *voucher = [[voucherVC alloc]init];
        [self.navigationController pushViewController:voucher animated:YES];
    }
}
@end

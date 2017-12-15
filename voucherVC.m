//
//  voucherVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/19.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "voucherVC.h"
#import "NetWorkingObj.h"
static NSString *cellIdentifier = @"voucherCell";
@interface voucherVC()<UITableViewDelegate,UITableViewDataSource,NetWorkingDelegate>
@property UITableView *tableview;
@property NSArray *list;
@end
@implementation voucherVC
- (void)viewDidLoad{
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_tableview];
    [_tableview registerClass:[voucherCell class] forCellReuseIdentifier:cellIdentifier];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.navigationItem.title = @"我的抵用劵";
    _tableview .backgroundColor = V_COLOR;
    self.view.backgroundColor = V_COLOR;
    [_tableview setTableFooterView:[UIView new]];
    [_tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
    
    NetWorkingObj *net = [NetWorkingObj shareInstance];
    [net getVoucher];
    net.delegate = self;
}
- (void)NetWorkingFinishGotVoucher:(NSArray *)vouchers{
    _list =  [NSArray arrayWithArray:vouchers];
    [_tableview reloadData];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    voucherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.isOpened = YES;
    [cell updateTheData:_list[indexPath.section]];
        return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(id cell) {
        [cell updateTheData:_list[indexPath.section]];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

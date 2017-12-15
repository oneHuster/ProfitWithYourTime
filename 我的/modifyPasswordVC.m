//
//  modifyPasswordVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/19.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "modifyPasswordVC.h"
#import "personalDataCell.h"
#import "NetWorkingObj.h"
#import "popupV.h"
@interface modifyPasswordVC()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titleList;
}
@property (nonatomic) NSMutableDictionary *infodic;
@end

static NSString *cellId = @"modifyPasswordcellId";
@implementation modifyPasswordVC

- (void)viewDidLoad{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.backgroundColor = V_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveTheAddressInfo)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.tableView registerClass:[personalDataCell class] forCellReuseIdentifier:cellId];
    titleList = @[@"旧密码",@"新密码",@"确认密码"];
    _infodic = [NSMutableDictionary dictionary];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = V_COLOR;
    return view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    personalDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell createTextField];
    [cell loadModelWithTitle:titleList[indexPath.row] AndItem:nil];
    cell.content.tag = indexPath.row;
    [cell.content addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//
- (void)textFieldEditChanged:(UITextField *)textField{
    if (textField.tag == 0) {
        [_infodic setObject:textField.text forKey:@"oldPwd"];
    }else if(textField.tag == 1){
        [_infodic setObject:textField.text forKey:@"newPwd"];
    }
    else if(textField.tag == 2)
        [_infodic setObject:textField.text forKey:@"newPwdConfirm"];
}
- (void)saveTheAddressInfo{
    if (_infodic[@"oldPwd"] && _infodic[@"newPwd"] &&_infodic[@"newPwdConfirm"]) {
        if ([_infodic[@"newPwd"] isEqualToString:_infodic[@"newPwdConfirm"]]) {
            NetWorkingObj *net = [NetWorkingObj shareInstance];
            [net modifyThePassword:_infodic];
        }
        else{
            popupV *popupv = [popupV initWithWarning:@"两次密码不一致"];
            [self.view addSubview:popupv];
            [popupv animationPresentAfterTimeInterval:0 AndDelay:4];
        }

    }
    else{
        popupV *popupv = [popupV initWithWarning:@"请将密码填写完整"];
        [self.view addSubview:popupv];
        [popupv animationPresentAfterTimeInterval:0 AndDelay:4];
    }

}
@end

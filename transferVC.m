//
//  payVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
//typedef NS_ENUM(NSInteger, PAYWAY) {
//    PAYWAYNone,//默认从0开始
//    PAYWAYWechat,
//    PAYWAYZhifubao
//};

#import "transferVC.h"
#define selected [UIImage imageNamed:@"selected"]
#define unselected [UIImage imageNamed:@"selectorEllipe"]
@interface transferVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UITextField *username;
    UITextField *password;
    UIButton *loginButton;
    NSInteger result;
}
@property UITableView *tableview;
@property NSArray *itemList;
@property (nonatomic,retain) NSArray *kindArray;//存储姓名的数组
//@property PAYWAY wayToPay;
@property UIButton *wechatBt;
@property UIButton *zhifubaoBt;
@end

static NSString *cellIdentifier = @"payCellId";
static NSString *cellId2 = @"payIconCellId";
@implementation transferVC

- (void)viewDidLoad{
//    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    self.navigationItem.title = @"充值";
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
//    [_tableview registerClass:[payIconCell class] forCellReuseIdentifier:cellId2];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    //[_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    
    _itemList = @[@"充值账户",@"支付方式"];
    _kindArray = @[@"余额转账",@"银行卡",@"支付宝", @"微信"];
//    username.backgroundColor = [UIColor whiteColor];
//    username.layer.cornerRadius = 3;
//    username.clipsToBounds = YES;
//    username.font = [UIFont systemFontOfSize:13];
//    
//    password.backgroundColor = [UIColor whiteColor];
//    password.layer.cornerRadius = 3;
//    password.clipsToBounds = YES;
//    password.font = [UIFont systemFontOfSize:13];
//    
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    loginButton.backgroundColor = Tint_COLOR;
//    [loginButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
//    loginButton.layer.cornerRadius = 3;
//    loginButton.clipsToBounds = YES;
////    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
////    _loginMessage = [UILabel new];
//    [self.view addSubview:username];
//    [self.view addSubview:password];
//    [self.view addSubview:loginButton];
//    
//    
//    
////    self.navigationItem.title = @"一卡通注册";
//    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];

//    [loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(password.mas_bottom).offset(20);
//        make.left.mas_equalTo(username.mas_left);
//        make.right.mas_equalTo(username.mas_right);
//        make.height.mas_equalTo(40);
//    }];

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = [_itemList objectAtIndex:indexPath.section];
    cell.textLabel.textColor = Font_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect textFieldRect = CGRectMake(100, 0.0f, 215.0f, 44.0f);
    UITextField *theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    theTextField.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    theTextField.returnKeyType = UIReturnKeyDone;
//    theTextField.secureTextEntry = YES;
    theTextField.clearButtonMode = YES;
    theTextField.tag = indexPath.section;
    if (indexPath.section == 1) {
        theTextField.inputView = [self pickerView];
        theTextField.text = @"银行卡";
        [theTextField.inputView addSubview:[self btn]];
    }
    else{
        UIImageView *icon_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contactor"]];
        icon_view.frame = CGRectMake(320, 7, 30, 30);
        [cell.contentView addSubview:icon_view];
    }
    theTextField.delegate = self;
    [cell.contentView addSubview:theTextField];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



//创建pickerView
- (UIPickerView *)pickerView
{
    //初始化一个PickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 300, 300, 200)];
    pickerView.tag = 1000;
    //指定Picker的代理
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    //是否要显示选中的指示器(默认值是NO)
    pickerView.showsSelectionIndicator = NO;
    
    return pickerView;
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //如果是第一列
//    if (component == 0) {
//        //返回姓名数组的个数
//        return self.nameArray.count;
//    }
//    else
//    {
//        //返回表情数组的个数
//        return self.iconArray.count;
//    }
    return 4;
}

#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 100;
    }
    else
    {
        return 80;
    }
    
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
//    if (component == 0) {
//        return 60;
//    }
//    else
//    {
//        return 60;
//    }
    return 30;
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    if (component == 0) {
//        return self.nameArray[row];
//    }
    return _kindArray[row];
//    else
//    {
//        return self.iconArray[row];
//    }
}



//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component == 0) {
//        NSLog(@"%@",self.nameArray[row]);
//        [pickerView selectedRowInComponent:0];
//        //        //重新加载数据
//        //        [pickerView reloadAllComponents];
//        //        //重新加载指定列的数据
//        //        [pickerView reloadComponent:1];
//    }
//    else
//    {
//        NSLog(@"%@",self.iconArray[row]);
//    }
    [pickerView selectedRowInComponent:0];
}

#pragma mark --- 传值
//懒加载
//- (UILabel *)nameLabel
//{
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 80, 40)];
//        
//        [self.view addSubview:_nameLabel];
//    }
//    return _nameLabel;
//}

//懒加载
//- (UILabel *)iconLabel
//{
//    if (!_iconLabel) {
//        _iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 100, 80, 40)];
//        
//        [self.view addSubview:_iconLabel];
//    }
//    
//    return _iconLabel;
//}

//创建btn
- (UIButton *)btn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(250, 0, 150, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:Tint_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

//btn的回调方法
- (void)btnAction: (UIButton *)sender
{
    //获取pickerView
    UIPickerView *pickerView = [self.view viewWithTag:1000];
    //选中的行
    result = [pickerView selectedRowInComponent:0];
    //赋值
//    self.nameLabel.text = self.nameArray[result];
//    return _kindArray[result];
//
//    NSInteger result1 = [pickerView selectedRowInComponent:1];
//    self.iconLabel.text = self.iconArray[result1];
    
}
@end

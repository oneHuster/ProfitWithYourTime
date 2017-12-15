//
//  editAddressVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/10.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "editAddressVC.h"
#import "editAddressCell.h"
#import "mePickView.h"
#import "NetWorkingObj.h"
#import "CoreDateManager.h"
#import "popupV.h"
static NSString *cellId = @"editCellId";

@interface editAddressVC()<UITextFieldDelegate,mePickViewDelegate,NetWorkingDelegate>{
    NSArray *titleList;
    NSString *citystring;
}
@property mePickView *pickView;
@property UITextField *cityText;
@end
@implementation editAddressVC
- (id)init{
    self = [super init];
    _infodic = [NSMutableDictionary dictionary];
    return self;
}
- (void)viewDidLoad{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.backgroundColor = V_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveTheAddressInfo)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.tableView registerClass:[editAddressCell class] forCellReuseIdentifier:cellId];
    titleList = @[@"姓名",@"联系方式",@"城市",@"地址"];
    
    _pickView = [[mePickView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 180)];
    _pickView.backgroundColor = V_COLOR;//[UIColor yellowColor];
    _pickView.delegate = self;
    //[self.view addSubview:_pickView];
    
}

- (void)saveTheAddressInfo{
    if (_infodic[@"userName"] && _infodic[@"phone"]  &&  _infodic[@"address"]) {
        NetWorkingObj *net = [NetWorkingObj shareInstance];

        if (_isNew) {

            [net addNewAddress:_infodic];
            net.delegate = self;
        }
        else{
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"editTheAddress" object:self];
            [net modifyAddress:_infodic];
            net.delegate = self;
        }
    }else{
        popupV *popupv = [popupV initWithWarning:nil
                          ];
        [self.view addSubview:popupv];
        [popupv animationPresentAfterTimeInterval:0 AndDelay:4];
    }
}

- (void)NetWorkingFinishedAddedAddress:(NSDictionary *)addressInfo{
    [_infodic setObject:addressInfo[@"ID"] forKey:@"id"];
    
    CoreDateManager *cache = [[CoreDateManager alloc]init];
    [cache addnewAddressWith:_infodic];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveNewAddress" object:self];
}
- (void)NetWorkingFinishedModifyAddress:(NSDictionary *)addressInfo{
    CoreDateManager *cache = [[CoreDateManager alloc]init];
    [cache updateWithModifyAddress:_infodic];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"editTheAddress" object:self];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = V_COLOR;
    return view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    editAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell updateWithModel:titleList[indexPath.row]];
    cell.field.tag = indexPath.row;
    if (indexPath.row == 0)
        cell.field.text = _infodic[@"userName"];
    else if (indexPath.row ==1)
        cell.field.text = _infodic[@"phone"];
    else if (indexPath.row ==2){
        cell.field.inputView = _pickView;
        cell.field.text = [NSString stringWithFormat:@"%@%@%@",_infodic[@"province"],_infodic[@"city"],_infodic[@"district"]];
        _cityText  = cell.field;
    }
    else
        cell.field.text = _infodic[@"address"];
    [cell.field addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)selectProvince:(NSString *)province City:(NSString *)city andDis:(NSString *)dis{
    [_infodic setObject:province forKey:@"province"];
    [_infodic setObject:city forKey:@"city"];
    [_infodic setObject:dis forKey:@"district"];
    _cityText.text = [NSString stringWithFormat:@"%@%@%@",_infodic[@"province"],_infodic[@"city"],_infodic[@"district"]];
}

- (void)textFieldEditChanged:(UITextField *)textField{
    if (textField.tag == 0) {
        [_infodic setObject:textField.text forKey:@"userName"];
    }else if(textField.tag == 1)
        [_infodic setObject:textField.text forKey:@"phone"];
    else if(textField.tag == 3)
        [_infodic setObject:textField.text forKey:@"address"];
}

@end

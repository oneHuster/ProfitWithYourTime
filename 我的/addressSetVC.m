//
//  addressSetVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/23.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "addressSetVC.h"
#import "addressCell.h"
#import "editAddressVC.h"
#import "CoreDateManager.h"
@interface addressSetVC()<UITableViewDataSource,UITableViewDelegate,editAddressDelegate>
//@property UITableView *tableview;
@property NSMutableArray<NSDictionary*> *list;
@property editAddressVC *editVc;
@end
static NSString *cellId = @"addressSetCellId";
@implementation addressSetVC
- (void)viewDidLoad
{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.backgroundColor = V_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *addAddress = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewAddress)];
    self.navigationItem.rightBarButtonItem = addAddress;
    self.navigationItem.title = @"常用地址";
    //self. = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:[addressCell class] forCellReuseIdentifier:cellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self.view addSubview:.tableview];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveNewAddressButtonPressed) name:@"saveNewAddress" object:_editVc];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editAdressInvoke) name:@"editTheAddress" object:_editVc];
    
    CoreDateManager *cache = [[CoreDateManager alloc]init];
    _list = [NSMutableArray arrayWithArray:[cache selectWithAddress]];


}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    
}
- (void)addnewAddress{
    _editVc = [[editAddressVC alloc]init];
    _editVc.delegate = self;
    _editVc.isNew = YES;
    _editVc.tag = -1;
    [self.navigationController pushViewController:_editVc animated:YES];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell updateWithModel:_list[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _list.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:cellId configuration:^(id cell) {
        [cell updateWithModel:_list[indexPath.row]];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _editVc = [[editAddressVC alloc]init];
    _editVc.infodic  = [NSMutableDictionary dictionaryWithDictionary:_list[indexPath.row]];
    _editVc.delegate = self;
    _editVc.isNew = NO;
    _editVc.tag = indexPath.row;
    
    [self.navigationController pushViewController:_editVc animated:YES];
}


- (void)saveNewAddressButtonPressed{
        [_list addObject:_editVc.infodic];
        [self.tableView reloadData];
}
- (void)editAdressInvoke{
    [_list replaceObjectAtIndex:_editVc.tag withObject:_editVc.infodic];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        CoreDateManager *cache = [[CoreDateManager alloc]init];
        NSDictionary *dic = _list[indexPath.row];
        [cache deleteDataWithTable:@"Address" andId:dic[@"id"]];
        [_list removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row] ];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:[self._fmdbOperate.datas objectAtIndex:indexPath.row]];
        
        [self.tableView reloadData];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


@end

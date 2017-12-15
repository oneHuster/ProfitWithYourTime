//
//  grabOrderVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/23.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "grabOrderVC.h"
#import "messageCell.h"
#import "NetWorkingObj.h"
#import "CoreDateManager.h"
#import "confirmPopVC.h"
#import "receiveMdl.h"
@interface grabOrderVC ()<UITableViewDataSource,UITableViewDelegate,NetWorkingDelegate>
@property UITableView *tableview;
@property NSMutableArray *cacheList;
@end
static NSString *commonCellIdentifier = @"grabOrderCell";
@implementation grabOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableview= [[UITableView alloc]initWithFrame:self.view.frame];
    [self.tableview registerClass:[messageCell class] forCellReuseIdentifier:commonCellIdentifier];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
    self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    
    self.tableview.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    self.navigationItem.title = @"抢单";
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
#pragma mark ==========订单已完成信息
//    for (orderMdl *order in _list) {
        NetWorkingObj *working = [NetWorkingObj shareInstance];
        working.delegate = self;
        [working getMeOrderIsOk:10];
//    }
//    CoreDateManager *cache = [[CoreDateManager alloc]init];
//    if (!_cacheList)
//       _cacheList = [cache selectWithGrabOrderMsg];
    [self hideTheTabbar];
    //[_tableview reloadData];
    _list = [NSMutableArray array];
}

- (void)viewDidDisappear:(BOOL)animated{
//    CoreDateManager *cache = [[CoreDateManager alloc]init];
//    [cache insertCoreData:_list];
}

- (void)NetWorkingFinishedGotReceiver:(NSArray *)receivers{
    
    for (NSDictionary *dic in receivers) {
        receiveMdl *receive = [receiveMdl initFromDictionary:dic];
        [_list addObject:receive];
    }
    
    [_tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if (section == 0)
       return _list.count;
//    else
//        return _cacheList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier];
    
    //[self initWithComment];
    if (indexPath.section==0){
        [cell initWithReceiver:_list[indexPath.row]];
        [cell createWithGrabButton:^{
            
        }];
    }
//    else
//        [cell initWithModel:_cacheList[indexPath.row]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableview fd_heightForCellWithIdentifier:commonCellIdentifier cacheByIndexPath:indexPath configuration:^(messageCell *cell) {
        if (indexPath.section == 0){
            [cell initWithReceiver:_list[indexPath.row]];
            [cell createWithGrabButton:^{
                
            }];
        }
//        else
//            [cell initWithModel:_cacheList[indexPath.row]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end

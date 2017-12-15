//
//  receivePraiseVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/23.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "receivePraiseVC.h"
#import "messageCell.h"

@interface receivePraiseVC ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *tableview;
@end
static NSString *commonCellIdentifier = @"receivePraiseCell";

@implementation receivePraiseVC

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
    self.navigationItem.title = @"收到的赞";
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self hideTheTabbar];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier];
    
    [cell initWithModel:_list[indexPath.row]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableview fd_heightForCellWithIdentifier:commonCellIdentifier cacheByIndexPath:indexPath configuration:^(messageCell *cell) {
        [cell initWithModel:_list[indexPath.row]];
    }];
}

@end

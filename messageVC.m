//
//  messageVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "messageVC.h"
#import "messageTableViewCell.h"
#import "UIView+drawLine.h"
#import "receiveComentVC.h"
#import "receivePraiseVC.h"
#import "grabOrderVC.h"
#import "NetWorkingObj.h"
#import "NSString+timeFormat.h"
@interface messageVC ()<UITableViewDataSource,UITableViewDelegate,NetWorkingDelegate>
@property UITableView *tableview;
@property NetWorkingObj *networking;
@property NSArray *messageList;

@property BOOL newPraise;
@property BOOL newGrab;
@property BOOL newComment;

@property NSString *lastComment;
@property NSString *lastPraise;
@property NSString *lastGrab;

@property NSMutableArray *commentArr;
@property NSMutableArray *praiseArr;
@property NSMutableArray *grabArr;

@end
static NSString *cellIdentifier = @"cellidentifier";
@implementation messageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [self createWithTableView];
    [self startLoop];
    

}
-(void)viewDidAppear:(BOOL)animated{
    [self presentTabbar];
}
- (void)viewWillAppear:(BOOL)animated{
    [_tableview reloadData];
}



- (void)startLoop

{
    
    [NSThread detachNewThreadSelector:@selector(loopMethod) toTarget:self withObject:nil];
    _networking = [NetWorkingObj shareInstance];
    _networking.delegate = self;
}


- (void)loopMethod

{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(requestIsHaveReview) userInfo:nil repeats:YES];
    [timer fire];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    
    [loop run];
    
}

- (void)requestIsHaveReview{
    [_networking getPushMessage];
    [_networking getPublicMessage];
}

- (void)NetWorkingFinishedGotMessage:(NSArray *)list{
    _messageList = list;
    _commentArr = [NSMutableArray array];
    _praiseArr = [NSMutableArray array];
    _grabArr = [NSMutableArray array];
    for (NSMutableDictionary *dic in list)
    {
        orderMdl *order = [orderMdl initFromDictionary:dic];
        if (order.statu == 20020008){
            _newComment = YES;
            [_commentArr addObject:order];
        }
        else if (order.statu == 20020006){
            _newPraise = YES;
            [_praiseArr addObject:order];
        }
        else if (order.statu == 20020009){
            _newGrab = YES;
            [_grabArr addObject:order];
        }
    }
    
    orderMdl *lastone = [_commentArr lastObject];
    if (lastone.creator.nickName)
        _lastComment = [NSString stringWithFormat:@"%@评论了你   %@",lastone.creator.nickName,[NSString compareCurrentTime:lastone.createtime]];
    lastone = [_praiseArr lastObject];
    if (lastone)
        _lastPraise = [NSString stringWithFormat:@"%@赞了你    %@", lastone.creator.nickName,[NSString compareCurrentTime:lastone.createtime]];

    lastone = [_grabArr lastObject];
    if (lastone)
        _lastPraise = [NSString stringWithFormat:@"%@抢了你的单    %@", lastone.creator.nickName,[NSString compareCurrentTime:lastone.createtime]];
    
    [_tableview reloadData];
}

- (void)createWithTableView{
    self.flagImages = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"收到的评论.png"],[UIImage imageNamed:@"收到的赞.png"], [UIImage imageNamed:@"抢单.png"],[UIImage imageNamed:@"闲么.png"],nil];
    self.itemsTitle = [NSArray arrayWithObjects:@"收到的评论",@"收到的赞",@"抢单",@"闲么",nil];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.tableview];
    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self.tableview registerClass:[messageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.tableview setTableFooterView:[UIView new]];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
   
    
    cell.redDotV.hidden = YES;
    if (indexPath.row == 0 ){
        [cell updateWithIcon:_flagImages[indexPath.row] AndTitle:_itemsTitle[indexPath.row] AndDetailInfo:_lastComment and:YES];
        
        if (_newComment)
            cell.redDotV.hidden = NO;
    }
    else if (indexPath.row == 1){
        [cell updateWithIcon:_flagImages[indexPath.row] AndTitle:_itemsTitle[indexPath.row] AndDetailInfo:_lastPraise and:YES];
        
        if (_newPraise)
            cell.redDotV.hidden = NO;
    }
    else if (indexPath.row == 2){
        [cell updateWithIcon:_flagImages[indexPath.row] AndTitle:_itemsTitle[indexPath.row] AndDetailInfo:_lastGrab and:YES];
        
        if (_newGrab)
            cell.redDotV.hidden = NO;
    }
    else if (indexPath.row  == 3){
         [cell updateWithIcon:_flagImages[indexPath.row] AndTitle:_itemsTitle[indexPath.row] AndDetailInfo:@"" and:YES];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsTitle.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0,15,0,15);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        switch (indexPath.row) {
            case 0:{
                receiveComentVC *reVC= [[receiveComentVC alloc]init];
//                reVC.list = [NSMutableArray array];
               
//                for ( NSMutableDictionary *dic in _messageList)
//                {
//                    orderMdl *order = [orderMdl initFromDictionary:dic];
//                    if (order.statu == 20020008)
//                        [reVC.list addObject:order];
//                }
                reVC.list = [NSMutableArray arrayWithArray:_commentArr];

                [self.navigationController pushViewController:reVC animated:YES];
                _newComment = NO;
            }
                break;
            case 1:{
                receivePraiseVC *praVC = [[receivePraiseVC alloc]init];
//                praVC.list = [NSMutableArray array];
//                for (NSMutableDictionary *dic in _messageList)
//                {
//                    orderMdl *order = [orderMdl initFromDictionary:dic];
//                    if (order.statu == 20020006)
//                        [praVC.list addObject:order];
//                }
                praVC.list = [NSMutableArray arrayWithArray:_praiseArr];
//                orderMdl *lastone = [praVC.list lastObject];
//                    _lastPraise = [NSString stringWithString:lastone.creator.nickName];
                
                [self.navigationController pushViewController:praVC animated:YES];
                _newPraise = NO;
            }
                break;
            case 2:{
                grabOrderVC *grabOrd = [[grabOrderVC alloc]init];
//                grabOrd.list = [NSMutableArray array];
//                for (NSMutableDictionary *dic in _messageList) {
//                    orderMdl *order = [orderMdl initFromDictionary:dic];
//                    if (order.statu == 20020009)
//                        [grabOrd.list addObject:order];
//                }
                grabOrd.list = [NSMutableArray arrayWithArray:_grabArr];
//                orderMdl *lastone = [grabOrd.list lastObject];
//                    _lastGrab = [NSString stringWithString:lastone.creator.nickName];
                
                [self.navigationController pushViewController:grabOrd animated:YES];
                _newGrab = NO;
            }
                break;
            case 3:
                break;
            default:
                break;
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end

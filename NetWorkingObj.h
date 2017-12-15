//
//  NetWorkingObj.h
//  闲么
//
//  Created by 邹应天 on 16/3/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMdl.h"
#import "orderMdl.h"
#import <AFNetworking/AFNetworking.h>

@protocol NetWorkingDelegate <NSObject>

@optional
- (void)NetWorkingFinishLoginWithStatu:(NSString*)status;

- (void)NetWorkingFinishedWithLoadList:(NSArray*)list;

- (void)NetWorkingFailedToRequest:(NSError*)error;
//图片上传完成回调
- (void)NetWorkingFinishedLoadImages:(NSString*)ImageUrl;

- (void)NetWorkingFinishedWithGrab:(NSDictionary*)statuDic;

- (void)NetWorkingFinishedGotMessage:(NSArray*)list;
//需求回调
- (void)NetWorkingFinishedWithNeeds:(NSArray*)list;
//赞过的回调
- (void)NetWorkingFinishedWithPraised:(NSArray*)list;
//帮助过回调
- (void)NetWorkingFailedWithMyHelped:(NSArray*)list;
//抢到未确认订单
- (void)NetWorkingFinishedWithUnconfirmedOrder:(NSArray *)list;

//获取接单人接单信息
- (void)NetWorkingFinishedGotReceiver:(NSArray*)receivers;

//抵用劵回调
- (void)NetWorkingFinishGotVoucher:(NSArray*)vouchers;

//修改地址
- (void)NetWorkingFinishedAddedAddress:(NSDictionary*)addressInfo;
- (void)NetWorkingFinishedModifyAddress:(NSDictionary*)addressInfo;
@end



@interface NetWorkingObj : NSObject<NetWorkingDelegate>

@property (nonatomic,weak)id<NetWorkingDelegate>delegate;
@property (nonatomic,weak)NSMutableArray *orderList;


+ (NetWorkingObj*)shareInstance;
//注册

- (void)regiterToServer:(NSString *)phoneNum andPassword:(NSString*)password;

//用户登录
- (void)loginWithPhone:(NSString*)phoneNum andPassword:(NSString*)password;

//发布订单到服务器
- (void)publishOrderToServer:(orderMdl*)orderModel;

//加载订单
- (void)loadTheOrdersWithCounts:(NSUInteger)count andCity:(NSString*)citykey andKey:(NSString*)keyWord andOrderBy:(NSString*)orderBy andX:(NSInteger)latitude andY:(NSInteger)longitude;

//上传图片
- (void)upLoadImages:(UIImage*)image;

//上传头像
- (void)upLoadfavicon:(UIImage*)favicon;

//用户修改资料
- (void)userModifyProfile;

//抢单
- (void)grabTheOrder:(orderMdl*)order;

//抢到待确认的订单
- (void)getTheUnconfirmedOrder:(NSInteger)count;

// 我的需求
- (void)getMyNeedsOrder:(NSUInteger)count;

//获取消息
- (void)getPushMessage;

//设置消息已读
- (void)finishReadingMessage:(orderMdl*)order;

//我赞过的
- (void)getMyPraisedOrder:(NSInteger)count;

//新增收获地址
- (void)addNewAddress:(NSDictionary*)dic;

//修改收货地址
- (void)modifyAddress:(NSDictionary*)dic;


//获取我发布待确认的订单
- (void)getMeOrderIsOk:(NSInteger)count;

//确认接单人
- (void)confirmTheOrder:(orderMdl*)order;

//获取官方消息
- (void)getPublicMessage;

//获取我抢到的订单
- (void)getMyHelpOrder:(NSInteger)count;

//评论
- (void)addCommentToOrder:(orderMdl*)order;

//获取抵用劵
- (void)getVoucher;

//修改密码
- (void)modifyThePassword:(NSDictionary*)pwdDic;
@end

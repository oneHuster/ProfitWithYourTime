//
//  orderMdl.h
//  闲么
//
//  Created by 邹应天 on 16/3/2.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMdl.h"
@interface orderMdl : NSObject

@property (nonatomic,copy)NSString *orderName;//订单名称
@property NSInteger orderId;//订单id
@property NSInteger userId;//发布人id
@property (nonatomic,copy)NSString *title;//订单标题
@property (nonatomic,copy)NSString *des;//订单内容
@property NSInteger money;//订单本金
@property (nonatomic,copy)NSString *province;//省
@property (nonatomic,copy)NSString *city;//市
@property (nonatomic,copy)NSString *dis;//区
@property (nonatomic,copy)NSString *address;//街道地址
@property (nonatomic,copy)NSString *name;//收货人
@property (nonatomic,copy)NSString *phone;//收货电话
@property (nonatomic,copy)NSString *createtime;//订单时间
@property (nonatomic,copy)NSString *createtimeBynow;//时间差
@property (nonatomic,copy)NSString *receiveTime;
@property NSInteger statu;

@property (nonatomic,copy)NSArray *iMgs;//图片链接
@property NSInteger tip;//小费
@property NSString *position;//位置
@property NSString *sound;//语音
@property NSInteger praiseNum;
@property NSArray *comment;
@property NSArray *receiver;//接单人

@property (nonatomic) UserMdl *creator;

+ (orderMdl*)initFromDictionary:(NSDictionary*)dic;
- (BOOL)isMe:(NSInteger)userId;
@end

//
//  receiveMdl.h
//  闲么
//
//  Created by 邹应天 on 16/4/12.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "orderMdl.h"
#import "UserMdl.h"
@interface receiveMdl : NSObject

@property NSInteger receMdlId;
@property NSInteger orderId;//订单id
@property NSInteger userId;//发布人id
@property (nonatomic,copy)NSString *title;//订单标题
@property (nonatomic,copy)NSString *des;//订单内容
@property (nonatomic,copy)NSString *name;//收货人
@property (nonatomic,copy)NSString *phone;//收货电话
@property (nonatomic,copy)NSString *createtime;//订单时间
@property NSInteger statu;

@property orderMdl *o_order;
//@property UserMdl *u_receiver;
+ (receiveMdl*)initFromDictionary:(NSDictionary*)dic;
@end

//
//  receiveMdl.m
//  闲么
//
//  Created by 邹应天 on 16/4/12.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "receiveMdl.h"

@implementation receiveMdl

+ (receiveMdl*)initFromDictionary:(NSDictionary *)dic{
    receiveMdl *receiver = [[receiveMdl alloc]init];
        receiver.receMdlId = [dic objectForKey:@"ID"]?[[dic objectForKey:@"ID"]integerValue]:0;
    //receiver.receMdlId = [dic objectForKey:@""]
    receiver.userId = [[dic objectForKey:@"UserID"]integerValue];
    receiver.title = [dic objectForKey:@"OrderTitle"];
    receiver.name = [dic objectForKey:@"UserName"];
    receiver.statu = [[dic objectForKey:@"Type"]integerValue];
    receiver.createtime = [dic objectForKey:@"CreateTime"];
    receiver.des = [dic objectForKey:@"Des"];
    if (dic[@"O_Order"]!= [NSNull null])
        receiver.o_order  = [orderMdl initFromDictionary:[dic objectForKey:@"O_Order"]];
    if (dic[@"U_Member"]!= [NSNull null])
        receiver.o_order.creator = [UserMdl createFromJSON:dic[@"U_Member"]];
    return receiver;

}
@end;

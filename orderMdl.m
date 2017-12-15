//
//  orderMdl.m
//  闲么
//
//  Created by 邹应天 on 16/3/2.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "orderMdl.h"

@implementation orderMdl

+ (orderMdl*)initFromDictionary:(NSDictionary *)dic{
    orderMdl *ordmdl = [[orderMdl alloc]init];
    ordmdl.orderId = [dic objectForKey:@"ID"]?[[dic objectForKey:@"ID"]integerValue]:0;
    ordmdl.orderName = [dic objectForKey:@"OrderName"];
    ordmdl.userId = [[dic objectForKey:@"UserID"]integerValue];
    ordmdl.title = [dic objectForKey:@"Title"];
    ordmdl.money = [[dic objectForKey:@"Money"]integerValue];
    ordmdl.city = [dic objectForKey:@"City"];
    ordmdl.name = [dic objectForKey:@"Name"];
    ordmdl.address = [dic objectForKey:@"Address"];
    ordmdl.dis = [dic objectForKey:@"Dis"];
    ordmdl.position = [dic objectForKey:@"Position"];
    ordmdl.province = [dic objectForKey:@"Province"];
    ordmdl.phone  = [dic objectForKey:@"Phone"];
    ordmdl.tip = [dic objectForKey:@"Tip"]?[[dic objectForKey:@"Tip"]integerValue]:0;
    ordmdl.statu = [[dic objectForKey:@"Type"]integerValue];

    if ([[dic objectForKey:@"Imgs"]length]>3){
        NSString *string = [dic objectForKey:@"Imgs"];
        ordmdl.iMgs = [string componentsSeparatedByString:@";"];

    }
    
    ordmdl.createtime = [dic objectForKey:@"CreateTime"];
    ordmdl.receiveTime = [dic objectForKey:@"ReceivingTime"];
    ordmdl.des = [dic objectForKey:@"Des"];
    //ordmdl.des = @"qisdngn我 acne官方那烦恼分我发的女法官俄方杰尼索夫大脑放松的烦恼改变的奶粉事件地方 的";
    
    if (dic[@"LikeCount"]>0)
       ordmdl.praiseNum = [[dic objectForKey:@"LikeCount"]integerValue];
    else
       ordmdl.praiseNum = 0;
    ordmdl.comment = [dic objectForKey:@"O_Comment"]?[dic objectForKey:@"O_Comment"]:[NSArray array];
    //creator info
    if ([dic objectForKey:@"U_Member"]!=[NSNull null])
        ordmdl.creator = [UserMdl createFromJSON:[dic objectForKey:@"U_Member"]];
    NSArray *arrayReceives = dic[@"O_Receive"];
    if ([dic objectForKey:@"O_Receive"]!=[NSNull null] && arrayReceives.count>0)
        ordmdl.receiver = [dic objectForKey:@"O_Receive"];
    
    return ordmdl;
}

- (BOOL)isMe:(NSInteger)userId{
    for (NSDictionary *recei in self.receiver) {
        if ( [recei[@"UserId"]integerValue]==userId ) {
            return YES;
        }
    }
    return NO;
}

@end

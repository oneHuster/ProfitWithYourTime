//
//  UserMdl.m
//  闲么
//
//  Created by 邹应天 on 16/3/1.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UserMdl.h"
@implementation UserMdl
+ (UserMdl*)getCurrentUserMdl{
    static UserMdl *sharedCLDelegate=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCLDelegate =[[UserMdl alloc]init];
    });
    return sharedCLDelegate;
}

+ (UserMdl*)createFromJSON:(NSDictionary *)dic{
    UserMdl *creator = [[UserMdl alloc]init];
    creator.userId = [[dic objectForKey:@"ID"]integerValue];
    creator.age = [[dic objectForKey:@"Age"]integerValue];
    creator.nickName = [dic objectForKey:@"NickName"];
    creator.phone = [dic objectForKey:@"Phone"];
    creator.faviconUrl = [NSString stringWithFormat:@"http://123haomai.cn:90%@",[dic objectForKey:@"Photo"]];;
    creator.myWords = [dic objectForKey:@"Mood"];
    return creator;
}
@end

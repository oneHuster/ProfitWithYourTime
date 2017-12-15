//
//  UserMdl.h
//  闲么
//
//  Created by 邹应天 on 16/3/1.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMdl : NSObject
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *phone;
@property (assign)NSInteger sex;//0表示boy，1表示girl
@property NSInteger age;
@property NSInteger userId;
@property (nonatomic,copy)NSString *pwd;
@property (nonatomic,copy)NSString *faviconUrl;//点击放大的头像地址


@property (nonatomic,copy)NSString *smallIconUrl;//小头像对应地址
@property (nonatomic,copy)NSString *HomePlace;//常住地
@property NSUInteger birthDay;//eg:941120
@property (nonatomic,copy)NSString *myWords;

+ (UserMdl*)getCurrentUserMdl;

+ (UserMdl*)createFromJSON:(NSDictionary*)dic;
@end

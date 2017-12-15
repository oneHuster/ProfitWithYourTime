//
//  homePageModel.h
//  闲么
//
//  Created by 邹应天 on 16/3/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMdl.h"
#import "orderMdl.h"
@interface homePageModel : NSObject

@property (nonatomic,copy)NSString* username;
@property (nonatomic)UIImage *favicon;
@property NSInteger sex;
@property NSInteger age;
//@property (nonatomic,copy)NSString *smallIconUrl;//小头像对应地址
//@property (nonatomic,copy)NSString *iconUrl;//点击放大的头像地址
//@property (nonatomic,copy)NSString *HomePlace;//常住地
//@property NSUInteger birthDay;//eg:941120
@property (nonatomic,copy)NSString *myWords;
- (void)getCurrentUserAndInfo;
@end

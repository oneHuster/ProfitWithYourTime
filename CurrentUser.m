//
//  CurrentUser.m
//  闲么
//
//  Created by 邹应天 on 16/3/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser
+(CurrentUser*)sharedInstance{
    static CurrentUser *sharedCLDelegate=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCLDelegate =[[CurrentUser alloc]init];
        
    });
    return sharedCLDelegate;
}
@end

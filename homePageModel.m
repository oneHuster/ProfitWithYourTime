//
//  homePageModel.m
//  闲么
//
//  Created by 邹应天 on 16/3/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "homePageModel.h"
#import "UserMdl.h"
#import "orderMdl.h"
#import "NetWorkingObj.h"
@interface homePageModel()
@property UserMdl *currentUser;
@end
@implementation homePageModel

- (void)getCurrentUserAndInfo{
    _currentUser = [UserMdl getCurrentUserMdl];
    _username = _currentUser.nickName;
    //_favicon = _currentUser.
    _sex = _currentUser.sex;
    _age = _currentUser.age;
    _myWords = _currentUser.myWords;
}
//- (NSArray*)loadTheCellList{
//    NetWorkingObj * netObj = [NetWorkingObj shareInstance];
//    NSArray *array = [NSArray array];
//    return array;
//}
@end

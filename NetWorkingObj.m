　//
//  NetWorkingObj.m
//  闲么
//
//  Created by 邹应天 on 16/3/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.


#import "NetWorkingObj.h"
#import "NSString+SHA1HMAC.h"
#import "NSString+hmac_sha1.h"
#import <CoreData/CoreData.h>

const NSString *key = @"2CAo2C1jP0";
@implementation NetWorkingObj
+ (NetWorkingObj*)shareInstance{
    static NetWorkingObj *sharedCLDelegate=nil;
    static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           sharedCLDelegate =[[NetWorkingObj alloc]init];
    });
    return sharedCLDelegate;
}

//注册操作
- (void)regiterToServer:(NSString *)phoneNum andPassword:(NSString *)password{
    __block NSString *status;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    
    const char *char_key = [key UTF8String];
    
    NSString *urlString = [NSString stringWithFormat:@"/Open/UMemberAdd?timestamp=%@&phone=%@&pwd=%@&_aop_appkey=999999",timestamp,phoneNum,password];
    NSString *signature = [NSString signature:urlString params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",urlString,signature];
    NSLog(@"%@",url);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[obj objectForKey:@"statusCode"]isEqualToNumber:@200]) {
    
        }else if([[obj objectForKey:@"statusCode"]isEqualToNumber:@300]){
            
        }
        status = [obj objectForKey:@"message"];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishLoginWithStatu:)]) {
            [self.delegate NetWorkingFinishLoginWithStatu:status];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//登录操作
- (void)loginWithPhone:(NSString *)phoneNum andPassword:(NSString *)password{
    __block NSString *status;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    NSString *urlString = [NSString stringWithFormat:@"/Open/UMemberLogin?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,phoneNum];
    NSString *signature = [NSString signature:urlString params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&pwd=%@&_aop_signature=%@",urlString,password,signature];
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",obj);
        UserMdl *CurrentUser = [UserMdl getCurrentUserMdl];
        if ([[obj objectForKey:@"statusCode"]isEqualToNumber:@200]) {
            
            NSDictionary *detailInfoDic = [obj objectForKey:@"Attr"];
            CurrentUser.nickName = [detailInfoDic objectForKey:@"NickName"];
            CurrentUser.phone = [detailInfoDic objectForKey:@"Phone"];
            CurrentUser.age = [[detailInfoDic objectForKey:@"Age"]integerValue];
            CurrentUser.userId = [[detailInfoDic objectForKey:@"ID"]integerValue];
            CurrentUser.faviconUrl =[NSString stringWithFormat:@"http://123haomai.cn:90%@",[detailInfoDic objectForKey:@"Photo"]];
            CurrentUser.myWords = [detailInfoDic objectForKey:@"Mood"];

        }else if([[obj objectForKey:@"statusCode"]isEqualToNumber:@300]){
            
        }
         status = [obj objectForKey:@"message"];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishLoginWithStatu:)]) {
            [self.delegate NetWorkingFinishLoginWithStatu:status];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        status = @"网络连接错误";
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishLoginWithStatu:)]) {
            [self.delegate NetWorkingFinishLoginWithStatu:status];
        }
    }];
}

//发布订单操作
- (void)publishOrderToServer:(orderMdl *)orderModel{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    NSString *key = @"2CAo2C1jP0";
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    //user.phone = @"15888888888";
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"/Open/CreateOrder?userId=%ld&timestamp=%@&phone=%@&orderName=%@&title=%@&des=%@&money=%ld&province=%@&city=%@&dis=%@&address=%@&name=%@&receivingTime=%@&_aop_appkey=999999",
                           (long)user.userId,
                           timestamp,user.phone,
                           [orderModel.orderName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.title   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.des   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           (long)orderModel.money,
                           [orderModel.province   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.city   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.dis   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.address
                            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [user.nickName   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [orderModel.receiveTime stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (orderModel.iMgs){
        [urlString appendString:[NSString stringWithFormat:@"&iMgs="]];
        for (int k = 0;k< orderModel.iMgs.count;k++) {
            if (orderModel.iMgs.count == 1) {
                [urlString appendString:[NSString stringWithFormat:@"%@",orderModel.iMgs[k]]];
            }
            else
                [urlString appendString:[NSString stringWithFormat:@"%@;",orderModel.iMgs[k] ]];
        }
    }
    
    NSString *urlString2 = [NSString stringWithFormat:@"/Open/CreateOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    
    NSString *signature = [NSString signature:urlString2 params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",urlString,signature];
    
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[obj objectForKey:@"message"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
 
}

//加载订单操作
- (void)loadTheOrdersWithCounts:(NSUInteger)count andCity:(NSString *)citykey andKey:(NSString *)keyWord andOrderBy:(NSString *)orderBy andX:(NSInteger)latitude andY:(NSInteger)longitude{
    //__block NSArray *list;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSMutableString *urlString;
    
        urlString = [NSMutableString stringWithFormat:@"/Open/OrderList?timestamp=%@&phone=%@&Index=%ld&Size=%d&_aop_appkey=999999",timestamp,user.phone,(unsigned long)count,3];
        if (citykey)
           [urlString appendString:[NSString stringWithFormat:@"&area=%@",[citykey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if (orderBy)
           [urlString appendString:[NSString stringWithFormat:@"&orderBy=%@",[orderBy stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if (keyWord)
            [urlString appendString:[NSString stringWithFormat:@"&key=%@",[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if (longitude!=0 && latitude != 0)
            [urlString appendString:[NSString stringWithFormat:@"&x=%ld&y=%ld",(long)latitude,longitude]];
    NSString *signature = [NSString signature:urlString params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",urlString,signature];
    NSLog(@"%@",url);
    
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",obj);
        //if ([[obj objectForKey:@"statusCode"]isEqualToNumber:@200]) {
            //[self.orderList addObject:[obj objectForKey:@"Attr"]];
            if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithLoadList:)]) {
                [self.delegate NetWorkingFinishedWithLoadList:[obj objectForKey:@"Attr"]];
            }
        //}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(NetWorkingFailedToRequest:)]) {
            [self.delegate NetWorkingFailedToRequest:error];
        }
    }];
    
}

//上传图片操作
- (void)upLoadImages:(UIImage*)image{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    //user.phone = @"15888888888";
    NSString *urlString = [NSString stringWithFormat:@"/Open/UpLoadOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:urlString params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",urlString,signature];
//    images = [NSArray arrayWithObject:[UIImage imageNamed:@"qqIcon.png"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileName;

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmm";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            //if (i==1) {
                fileName = [NSString stringWithFormat:@"%@.png",str];
//            }else{
//                fileName = [NSString stringWithFormat:@";%@%d.png",str,i++];
//            }
            NSData *data=UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/png"];

        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedLoadImages:)]) {
            [self.delegate NetWorkingFinishedLoadImages:[obj objectForKey:@"Data"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 上传头像
- (void)upLoadfavicon:(UIImage *)favicon{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *urlString = [NSString stringWithFormat:@"/Open/UpLoadUserImg?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:urlString params:nil key:char_key];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@&userId=%ld",urlString,signature,(long)user.userId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
            NSData *data=UIImagePNGRepresentation(favicon);
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedLoadImages:)]) {
//            [self.delegate NetWorkingFinishedLoadImages:[obj objectForKey:@"Data"]];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark -------------- 修改个人资料
- (void)userModifyProfile{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/UMemberModify?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    NSMutableString *postParams = [NSMutableString stringWithFormat:@"/Open/UMemberModify?timestamp=%@&phone=%@&sex=%ld&age=%ld&_aop_appkey=999999",timestamp,user.phone,(long)user.sex,(long)user.age];
    
    if (user.myWords)
        [postParams appendString:[NSString stringWithFormat:@"&mood=%@",[user.myWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  ]];
    
    if (user.pwd)
        [postParams appendString:[NSString stringWithFormat:@"&pwd=%@",user.pwd]];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[[obj objectForKey:@"message"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

//抢单
- (void)grabTheOrder:(orderMdl *)order{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/GrabOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];

    
    //=========================
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&orderId=%ld&orderUserId=%ld&orderTitle=%@&userName=%@&des=%@",encryptString,(long)user.userId,(long)order.orderId,(long)order.userId,[order.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[user.nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[order.des stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithGrab:)]) {
            [self.delegate NetWorkingFinishedWithGrab:obj];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

//抢到待确认订单
- (void)getTheUnconfirmedOrder:(NSInteger)count{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MyIsOkOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&index=%ld&size=%d",encryptString,(long)user.userId,(long)count,1];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithUnconfirmedOrder:)]) {
            [self.delegate NetWorkingFinishedWithUnconfirmedOrder:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


//获取消息
- (void)getPushMessage{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/PushMes?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld",encryptString,(long)user.userId];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedGotMessage:)]) {
            [self.delegate NetWorkingFinishedGotMessage:[obj objectForKey:@"Attr"]];
            NSLog(@"%@",[obj objectForKey:@"Attr"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//消息已读
- (void)finishReadingMessage:(orderMdl*)order{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MesState?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&mesId=%ld",encryptString,(long)user.userId,(long)order.orderId];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithLoadList:)]) {
            [self.delegate NetWorkingFinishedWithLoadList:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

//我的需求
- (void)getMyNeedsOrder:(NSUInteger)count{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MyOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&index=%ld&size=%d&state=%d",encryptString,(long)user.userId,(unsigned long)count,1,20050005];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithNeeds:)]) {
            [self.delegate NetWorkingFinishedWithNeeds:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


//我赞过的
- (void)getMyPraisedOrder:(NSInteger)count{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MyOrderLike?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&index=%ld&size=%d",encryptString,(long)user.userId,(long)count,1];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedWithPraised:)]) {
            [self.delegate NetWorkingFinishedWithPraised:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark -------------------新增地址
- (void)addNewAddress:(NSDictionary *)dic{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/UAddressAdd?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&name=%@&mobile=%@&province=%@&city=%@&dis=%@&address=%@",encryptString,
                            [dic[@"userName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [dic[@"phone" ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [dic[@"province"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [dic[@"city"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [dic[@"district"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [dic[@"address"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedAddedAddress:)]) {
            [self.delegate NetWorkingFinishedAddedAddress:obj[@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark------------修改收货地址
- (void)modifyAddress:(NSDictionary *)dic{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/UAddressAddModify?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSMutableString *postParams = [NSMutableString stringWithFormat:@"%@&id=%ld",encryptString,[dic[@"id"] integerValue]];
    
    if (dic[@"userName"]) {
        [postParams appendString:[NSString stringWithFormat:@"&name=%@",[dic[@"userName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (dic[@"province"]) {
        [postParams appendString:[NSString stringWithFormat:@"&province=%@",[dic[@"province"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (dic[@"city"]) {
        [postParams appendString:[NSString stringWithFormat:@"&city=%@",[dic[@"city"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (dic[@"phone"]) {
        [postParams appendString:[NSString stringWithFormat:@"&mobile=%@",[dic[@"phone" ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (dic[@"dis"]) {
       [postParams appendString:[NSString stringWithFormat:@"&dis=%@",[dic[@"district" ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (dic[@"address"]) {
        [postParams appendString:[NSString stringWithFormat:@"&address=%@",[dic[@"address"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",
              obj[@"statusCode"]]  isEqualToString:@"200"]) {
            if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedModifyAddress:)]) {
                [self.delegate NetWorkingFinishedModifyAddress:obj[@"Attr"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}



#pragma mark --------------确认接单人
- (void)confirmTheOrder:(orderMdl *)order{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/ConfirmOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *postParams = [NSString stringWithFormat:@"%@&receiveId=%ld&des=%@&userId=%ld",encryptString,(long)order.orderId,[order.des stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],user.userId];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getMeOrderIsOk:(NSInteger)count{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MeIsOkOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&index=%ld&size=%d",encryptString,(long)user.userId,(long)count,1];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedGotReceiver:)]) {
            [self.delegate NetWorkingFinishedGotReceiver:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

#pragma mark ---------闲么官方
- (void)getPublicMessage{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/PublicMes?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",encryptString,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishedGotReceiver:)]) {
//            [self.delegate NetWorkingFinishedGotReceiver:[obj objectForKey:@"Attr"]];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)getMyHelpOrder:(NSInteger)count{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MyConfirmOrder?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&index=%ld&size=%d",encryptString,(long)user.userId,(long)count,1];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(NetWorkingFailedWithMyHelped:)]) {
            [self.delegate NetWorkingFailedWithMyHelped:[obj objectForKey:@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
#pragma mark -------------评论
- (void)addCommentToOrder:(orderMdl *)order{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/OrderComment?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    
    NSString *postParams = [NSString stringWithFormat:@"%@&userId=%ld&orderId=%ld&orderTitle=%@&userName=%@&des=%@&toUserId=%ld",encryptString,(long)user.userId,(long)order.orderId,
                            [order.orderName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [user.nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [order.des stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            (long)order.userId];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getVoucher{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/MyCoupon?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&userId=%ld&_aop_signature=%@",encryptString,(long)user.userId,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([self.delegate respondsToSelector:@selector(NetWorkingFinishGotVoucher:)]) {
            [self.delegate NetWorkingFinishGotVoucher:obj[@"Attr"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

#pragma mark --------------修改密码
- (void)modifyThePassword:(NSDictionary *)pwdDic{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
    const char *char_key = [key UTF8String];
    UserMdl *user = [UserMdl getCurrentUserMdl];
    NSString *encryptString = [NSString stringWithFormat:@"/Open/UMemberModify?timestamp=%@&phone=%@&_aop_appkey=999999",timestamp,user.phone];
    NSString *signature = [NSString signature:encryptString params:nil key:char_key];
    NSMutableString *postParams = [NSMutableString stringWithFormat:@"%@&pwd=%@&newPwd=%@&_aop_appkey=999999",encryptString,pwdDic[@"oldPwd"],pwdDic[@"newPwd"]];
    
    NSString *url = [NSString stringWithFormat:@"http://123haomai.cn:90%@&_aop_signature=%@",postParams,signature];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[[obj objectForKey:@"message"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
@end

//
//  CurrentUser.h
//  闲么
//
//  Created by 邹应天 on 16/3/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject
+(CurrentUser*)sharedInstance;
@property NSString *userName;
@property NSString *sex;
@end

//
//  addressMdl.h
//  闲么
//
//  Created by 邹应天 on 16/4/18.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressMdl : NSObject

@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *district;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *address;
@property BOOL isDefault;
@end

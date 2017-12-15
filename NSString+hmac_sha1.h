//
//  NSString+hmac_sha1.h
//  闲么
//
//  Created by 邹应天 on 16/2/19.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (hmac_sha1)

+ (NSString *)signature:(NSString *)pathUrl params:(NSDictionary *)paramMap key:(const char *)cKey;
@end

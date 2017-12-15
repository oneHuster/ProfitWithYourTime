//
//  NSString+timeFormat.h
//  闲么
//
//  Created by 邹应天 on 16/3/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (timeFormat)

+ (NSString *) compareCurrentTime:(NSString *)str;

//得到年龄
+ (NSString*)ageFromDate:(NSString*)date;

//standard format
+ (NSString*)standardizeFormat:(NSString*)date;

+ (NSString*)standardizeFormatToyyyymmdd:(NSString*)date;

//standard  post format
+ (NSString*)standardizePostFormat:(NSString*)date;
@end

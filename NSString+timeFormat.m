//
//  NSString+timeFormat.m
//  闲么
//
//  Created by 邹应天 on 16/3/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "NSString+timeFormat.h"

@implementation NSString (timeFormat)

+ (NSString *) compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (NSString*)ageFromDate:(NSString *)date{
    //date = @"1993-10-30";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:date];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    
    return [NSString stringWithFormat:@"%d",age];
}

+ (NSString*)standardizeFormat:(NSString *)date{
    date = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //从接近格式中得到日期
    NSDate *getdate = [dateFormatter dateFromString:date];
    //转化为想要的格式
    [dateFormatter setDateFormat:@"yyyy年M月d日HH:mm"];
    return [dateFormatter stringFromDate:getdate];
}

+ (NSString*)standardizeFormatToyyyymmdd:(NSString *)date
{
    date = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //从接近格式中得到日期
    NSDate *getdate = [dateFormatter dateFromString:date];
    //转化为想要的格式
    [dateFormatter setDateFormat:@"yyyy-M-d"];
    return [dateFormatter stringFromDate:getdate];
}

+ (NSString*)standardizePostFormat:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //从接近格式中得到日期
    NSDate *getdate = [dateFormatter dateFromString:date];
    return [dateFormatter stringFromDate:getdate];
}
@end

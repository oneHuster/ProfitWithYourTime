//
//  NSString+getDeviceName.m
//  闲么
//
//  Created by 邹应天 on 16/3/4.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "NSString+getDeviceName.h"
#include <sys/types.h>
#include <sys/sysctl.h>
@implementation NSString (getDeviceName)


- (NSString*)hardwareDescription {
    NSString *hardware = [self hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([hardware isEqualToString:@"iPhone7,1"]) return @"iPhone 6P";
    if ([hardware isEqualToString:@"iPod1,1"]) return @"iPodTouch 1G";
    if ([hardware isEqualToString:@"iPod2,1"]) return @"iPodTouch 2G";
    if ([hardware isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([hardware isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad4,1"]) return @"iPad Air WIFI";
    //there are lots of other strings too, checkout the github repo
    //link is given at the top of this answer
    
    if ([hardware isEqualToString:@"i386"]) return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"]) return @"Simulator";
    
    return nil;
}

- (NSString*)hardwareString {
    size_t size = 100;
    char *hw_machine = malloc(size);
    int name[] = {CTL_HW,HW_MACHINE};
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}
@end

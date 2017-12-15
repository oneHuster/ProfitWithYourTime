//
//  NSString+hmac_sha1.m
//  闲么
//
//  Created by 邹应天 on 16/2/19.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "NSString+hmac_sha1.h"
#include <CommonCrypto/CommonHMAC.h>
#import "HMAC/NSString+SHA1HMAC.h"

@implementation NSString (hmac_sha1)
+ (NSString*)stringWithHexBytes:(NSData *)objData
{
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [objData length];
    const unsigned char* bytes = [objData bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    for (int i = 0; i<numBytes; ++i)
    {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    free(strbuf);
    return hexBytes;

}
+ (NSString *)hmacSha1ToHexStr:(NSString *)strData key:(const char *)cKey{
    const char *cData = [strData cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hmac = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [NSString stringWithHexBytes:hmac];
    return hash;
}



+ (NSString *)signature:(NSString *)pathUrl params:(NSDictionary *)paramMap key:(const char *)cKey{
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSRange range = [pathUrl rangeOfString:@"?"];
    NSString *baseUrl;
    if(range.length > 0)
    {
        baseUrl = [pathUrl substringToIndex:range.location];
        NSArray *chunks = [[pathUrl substringFromIndex:range.location+1] componentsSeparatedByString:@"&"];
        NSLog(@"%@",chunks);
        if(chunks){
            for (NSString *chunk in chunks) {
                NSRange prange = [chunk rangeOfString:@"="];
                if(range.length > 0)
                {
                    NSMutableString *tmp = [[NSMutableString alloc] initWithString:[chunk substringToIndex:prange.location]];
                    [tmp appendString:[chunk substringFromIndex:prange.location+1]];
                    [params addObject:tmp];
                }
                else
                {
                    [params addObject:chunk];
                }
            }
        }
    }else
    {
        baseUrl = pathUrl;
        NSLog(@"%@",baseUrl);
    }
    
    for (NSString *key in [paramMap allKeys])
    {
        NSMutableString *tmp = [[NSMutableString alloc] initWithString:key];
        NSString *value = [paramMap valueForKey:key];
        if(value)
        {
            [tmp appendString:value];
        }
        [params addObject:tmp];
    }
    [params sortUsingSelector:@selector(compare:)];
    //修正第一项
//        if ([params objectAtIndex:0]) {
//            NSString *firstItem = [params[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            NSLog(@"%@ %@",NSStringFromClass( [params[0] class]),NSStringFromClass([params[1] class]));
//            [params replaceObjectAtIndex:0 withObject:firstItem];
//            NSLog(@"%@",firstItem);
//
//        }
    NSLog(@"params is%@",params);
    NSMutableString *component = [[NSMutableString alloc]initWithString:baseUrl];
    [component appendString:@"999999"];
    for (int i = 1;i<params.count;i++) {
        if ([params[i]isKindOfClass:[NSString class]]) {
            [component appendString:params[i]];
        }
       
    }
    NSLog(@"%@",component);
//    CCHmacContext ctx;
//    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//    const char *cData = [baseUrl cStringUsingEncoding:NSUTF8StringEncoding];
//    CCHmacInit(&ctx, kCCHmacAlgSHA1, cKey, strlen(cKey));
//    CCHmacUpdate(&ctx, cData, strlen(cData));
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    for (NSString *param in params)
//    {
//        const char *cpData = [param cStringUsingEncoding:NSUTF8StringEncoding];
//        CCHmacUpdate(&ctx, cpData, strlen(cpData));
//    }
//    CCHmacFinal(&ctx, cHMAC);
//    NSData *hmac = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
   // NSString *hash = [NSString stringWithHexBytes:hmac];
    NSString *newKey = [NSString stringWithUTF8String:cKey];
    NSString *hash = [component SHA1HMACWithKey:newKey];
    NSLog(@"%@",hash);
    return hash;
}



@end

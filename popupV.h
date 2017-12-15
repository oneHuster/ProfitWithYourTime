//
//  popupV.h
//  闲么
//
//  Created by 邹应天 on 16/4/1.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popupV : UIView

+ (popupV*)initWithErrorInfo:(NSString*)string;

+ (popupV*)initWithWarning:(NSString*)string;

//设置出现和消失的时间
- (void)animationPresentAfterTimeInterval:(NSTimeInterval)present AndDelay:(NSTimeInterval)delay;
@end

//
//  UIButton+ButtonBlock.h
//  闲么
//
//  Created by 邹应天 on 16/4/18.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();

@interface UIButton (ButtonBlock)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

+ (UIButton*)createUniversalButtonTypeWithTitle:(NSString*)title;

@end

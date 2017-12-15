//
//  UIButton+ButtonBlock.m
//  闲么
//
//  Created by 邹应天 on 16/4/18.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UIButton+ButtonBlock.h"
#import <objc/runtime.h>

@implementation UIButton (ButtonBlock)

static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

+ (UIButton*)createUniversalButtonTypeWithTitle:(NSString *)title{
    UIButton *button  = [[UIButton alloc]init];
    button.layer.backgroundColor = Tint_COLOR.CGColor;
    button.layer.cornerRadius = 2;
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}
@end

//
//  MaskView.h
//  闲么
//
//  Created by 邹应天 on 16/1/26.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView


@property (nonatomic, strong) void (^ selectedAddButton)(void * buttonPressed);

@end

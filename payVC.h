//
//  payVC.h
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payVC : UIViewController

@property NSInteger money;
@property NSInteger tip;
@property (nonatomic)UIButton *grabButton;
@property NSString *orderId;
@end

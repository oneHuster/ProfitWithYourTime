//
//  detailVC.h
//  闲么
//
//  Created by 邹应天 on 16/2/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
typedef enum{
    DETAILTYPECELL,
    DETAILTYPEBUTTON
}DETAILTYPE;
#import <UIKit/UIKit.h>
#import "orderMdl.h"
#import "UserMdl.h"
@interface detailVC : UIViewController

@property DETAILTYPE type;
@property orderMdl *model;

@end

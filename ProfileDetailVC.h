//
//  ProfileDetailVC.h
//  闲么
//
//  Created by 邹应天 on 16/1/27.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

typedef NS_ENUM(NSInteger, PROFILEOPTIONTAG)
{
    OPTIONTAGINFO,
    OPTIONTAGHELP,
    OPTIONTAGNEEDS,
    OPTIONTAGPRAISE,
    OPTIONTAGWALLET,
    OPTIONTAGVOUCHER,
    OPTIONTAGCONNET,
    OPTIONTAGSETTING
};

#import <UIKit/UIKit.h>
#import "profile_option_model.h"

@interface ProfileDetailVC : UIViewController

@property PROFILEOPTIONTAG tag;
//@property (nonatomic,strong)void(^profileBlock)()
@end

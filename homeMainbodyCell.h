//
//  homeMainbodyCell.h
//  闲么
//
//  Created by 邹应天 on 16/1/23.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "cellModel.h"
@interface homeMainbodyCell : UITableViewCell

@property UILabel *content;
@property UILabel *title;

@property UILabel *username;
@property UILabel *publishTime;
@property UILabel *price;
@property UIToolbar *toolBar;
@property NSMutableArray *imageArray;
@property UIView *nineGridV;
@property UIButton *favicon;
@property CALayer *deviderLine;
-(void)initialWithModel;
//-(instancetype)initWithModel:
+ (CGFloat)heightWithModel;

@end

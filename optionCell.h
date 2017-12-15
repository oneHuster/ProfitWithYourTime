//
//  optionCell.h
//  闲么
//
//  Created by 邹应天 on 16/2/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface optionCell : UITableViewCell

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imageV;
@property UILabel *publishCountL;
@property UILabel *hotCountL;

-(void)createWithModels;
@end

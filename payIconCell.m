//
//  payIconCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "payIconCell.h"

@implementation payIconCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = Font_COLOR;
        self.detailTextLabel.textColor = Font_COLOR;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.font = [UIFont systemFontOfSize:8];
        //self.imageView.image = [UIImage imageNamed:@"wechatpay"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
       [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.topMargin.mas_equalTo(5);
           make.bottomMargin.mas_equalTo(5);
           make.centerY.equalTo(self.contentView);
           make.leftMargin.mas_equalTo(10);
           make.height.equalTo(self.imageView.mas_width);
       }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(5);
            make.top.equalTo(self.imageView);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(5);
            make.bottom.equalTo(self.imageView);

        }];
        
        _selectBt = [UIButton new];
        
        [self.contentView addSubview:_selectBt];
        [_selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(20);
            make.centerY.equalTo(self.contentView);
        }];
        
    }
    return self;
}
@end

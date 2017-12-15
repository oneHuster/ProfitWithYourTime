//
//  editAddressCell.m
//  闲么
//
//  Created by 邹应天 on 16/4/10.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "editAddressCell.h"



@implementation editAddressCell{
    UILabel *title;
    }
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    title = [UILabel new];
    title.textColor = Font_COLOR;
    [self.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leadingMargin.mas_equalTo(15);
        make.width.mas_equalTo(80);
    }];
    
    _field = [UITextField new];
    [self.contentView addSubview:_field];
    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(padding);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView).offset(-20);
        make.right.mas_equalTo(self.contentView).offset(-padding);
    }];
    _field.placeholder = @"未填写";
    return self;
}


- (void)updateWithModel:(NSString *)string{
    title.text = string;
}
@end

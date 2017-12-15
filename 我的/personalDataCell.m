//
//  personalDataCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/22.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "personalDataCell.h"
@interface personalDataCell()
@property UILabel *title;
@property UIImageView *faviconV;
@end
@implementation personalDataCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self) {
        _title = [UILabel new];
        _title.text = @"姓名";
        _title.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(65);
        }];
        
    }
    return self;
}
- (void)loadModelWithTitle:(NSString*)string AndItem:(NSString *)content
{
    _title.text = string;
    _content.text = content;
}

- (void)createTextField{
    if(!_content){
        _content = [UITextField new];
        //_content.placeholder = @"请选择性别";
        _content.font = [UIFont systemFontOfSize:13];
        _content.textColor = Font_COLOR;
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_title.mas_right).offset(20);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
        }];
    }

}
@end

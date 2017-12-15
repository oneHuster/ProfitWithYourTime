//
//  addressCell.m
//  闲么
//
//  Created by 邹应天 on 16/4/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "addressCell.h"
@interface addressCell()

@end
@implementation addressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _nickname = [UILabel new];
    [self.contentView addSubview:_nickname];
    [_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.leading.equalTo(self.contentView).offset(padding);
        make.height.mas_equalTo(15);
    }];
    
    _phone = [UILabel new];
    [self.contentView addSubview:_phone];
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-padding);
        make.top.equalTo(_nickname);
        make.height.mas_equalTo(15);
    }];
    
    _detail = [UILabel new];
    _detail.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_detail];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_nickname.mas_leading);
        make.top.equalTo(_nickname.mas_bottom).offset(padding);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
    
    return self;
}

- (void)updateWithModel:(NSDictionary *)dic{
    
    _nickname.text = [dic objectForKey:@"userName"];
    _phone.text = [dic objectForKey:@"phone"];
    _detail.text = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"province"],dic[@"city"],dic[@"district"],dic[@"address"]];
}
@end

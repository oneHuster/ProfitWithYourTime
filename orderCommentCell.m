//
//  orderCommentCell.m
//  闲么
//
//  Created by 邹应天 on 16/4/11.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "orderCommentCell.h"
#import "NSString+timeFormat.h"
#import "UIImageView+WebCache.h"
@interface orderCommentCell()
@property UIImageView *avatar;
@property UILabel *username;
@property UILabel *comment;
@property UILabel *publishTime;
@property UIView *seperatorLine;
@end
@implementation orderCommentCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    CGFloat height = self.bounds.size.height;
//    CGFloat width = self.bounds.size.width;
    _avatar = [UIImageView new];
    _avatar.layer.cornerRadius = 15;
    _avatar.clipsToBounds = YES;
    [self.contentView addSubview:_avatar];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.topMargin.mas_equalTo(8);
        make.size.mas_equalTo(30);
    }];
    
    _username = [UILabel new];
    _username.font = [UIFont systemFontOfSize:14];
    _username.textColor = [UIColor grayColor];
    [self.contentView addSubview:_username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(padding);
        make.centerY.mas_equalTo(_avatar);
        make.height.mas_equalTo(20);
    }];
    
    _publishTime = [UILabel new];
    _publishTime.font = [UIFont systemFontOfSize:12];
    _publishTime.textColor = Font_COLOR;
    [self.contentView addSubview:_publishTime];
    [_publishTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-padding);
        make.centerY.equalTo(_username);
        make.height.mas_equalTo(20);
    }];

    
    _comment = [UILabel new];
    _comment.textColor = Font_COLOR;
    _comment.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_comment];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatar.mas_bottom);
        make.left.equalTo(_username);
        make.right.mas_equalTo(_publishTime);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    _seperatorLine = [UIView new];
    _seperatorLine.backgroundColor = Font_COLOR;
    [self.contentView addSubview:_seperatorLine];
    [_seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leadingMargin.mas_equalTo(15);
        make.trailingMargin.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
        return self;
}

- (void)updateWithDictionary:(NSDictionary*)dic{
    NSDictionary *user = dic[@"U_Member"];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.haomai:90%@",user[@"Photo"]]] placeholderImage:[UIImage imageNamed:@"favicon"]];
    _username.text = dic[@"UserName"];
    _comment.text = dic[@"Des"];
    _publishTime.text = [NSString compareCurrentTime:dic[@"CreateTime"]];
}
@end

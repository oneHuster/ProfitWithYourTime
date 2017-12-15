//
//  messageTableViewCell.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "messageTableViewCell.h"

@implementation messageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self createLabel];
    [self createIcon];
    [self createWithRedDot];
    return self;
}

-(void)createLabel{
    self.label = [[UILabel alloc]init];
    //self.label.text = string;
    self.label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.label.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(self.mas_left).offset(70);
        //make.centerY.mas_equalTo(self.mas_centerY);
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    _detailInfoLb = [UILabel new];
    _detailInfoLb.textColor = Font_COLOR;
    [self.contentView addSubview:_detailInfoLb];
    _detailInfoLb.font = [UIFont systemFontOfSize:9];
    [_detailInfoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(5);
        make.left.equalTo(self.label);
    }];
}
-(void)createIcon{
    self.flagImage = [[UIImageView alloc]init];
    //设置图片原图适应imageview不做拉伸。
    self.flagImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.flagImage];
    [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.label.mas_left).offset(-18);
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
}

- (void)createWithRedDot{
    _redDotV = [UIImageView new];
    _redDotV.image = [UIImage imageNamed:@"newMessage"];
    [self.contentView addSubview:_redDotV];
    [_redDotV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(8);
        make.centerY.equalTo(_label);
        make.left.equalTo(_label.mas_right).offset(padding);
    }];
    _redDotV.hidden = YES;
}


- (void)updateWithIcon:(UIImage *)icon AndTitle:(NSString *)title AndDetailInfo:(NSString *)info and:(BOOL)newMessage{
    _flagImage.image = icon;
    _label.text = title;
    if (info)
        _detailInfoLb.text = info;
    else
        _detailInfoLb.text = @"";
}

@end

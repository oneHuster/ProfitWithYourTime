//
//  messageCell.m
//  闲么
//
//  Created by 邹应天 on 16/1/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "messageCell.h"
#import "NSString+timeFormat.h"
#import "UIImageView+WebCache.h"
#import "UIButton+ButtonBlock.h"

@interface messageCell()
@property UIImageView *favicon;
@property UILabel *username;
@property UILabel *details;
@property UILabel *time;
@property UIImageView *commodityImageV;
@end
@implementation messageCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.favicon = [UIImageView new];
        self.username = [UILabel new];
        self.details = [UILabel new];
        self.time = [UILabel new];
        self.commodityImageV = [UIImageView new];
//        [self initWithModel:]
        [self createFavicon];
        [self createUsername];
        [self createTime];
        [self createCommodityImage];
        
        _grabManagerBt = [UIButton new];
        [self.contentView addSubview:_grabManagerBt ];

    }
    return self;
}

- (void)initWithModel:(orderMdl *)model{
    [self.favicon sd_setImageWithURL:[NSURL URLWithString:model.creator.faviconUrl]];
    self.username.text = model.creator.nickName;
    self.details.text = model.des;
    self.time.text =  [NSString compareCurrentTime:model.createtime];
}

- (void)initWithReceiver:(receiveMdl *)receiver{
    //[_favicon sd_setImageWithURL:[NSURL URLWithString:model.creator.faviconUrl]];
    _username.text = receiver.name;
    _details.text = receiver.des;
    _time.text =  [NSString compareCurrentTime:receiver.createtime];
}

-(void)createFavicon{
    [self.contentView addSubview:self.favicon];
       [self.favicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(padding);
        make.top.mas_equalTo(self.contentView).offset(padding);
        make.height.and.width.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView).offset(-padding);
    }];
    self.favicon.layer.cornerRadius = 20;
    self.favicon.clipsToBounds = YES;
}
-(void)createUsername{
    self.username.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.username.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.username];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favicon).offset(5);
        make.left.mas_equalTo(self.favicon.mas_right).offset(padding);
        
    }];
    
    self.details.font = [UIFont systemFontOfSize:10];
    self.details.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.details];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.username.mas_bottom).offset(5);
        make.left.mas_equalTo(self.username);
        
    }];
}
-(void)createTime{
    self.time.font = [UIFont systemFontOfSize:10];
    self.time.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.username);
        make.left.mas_equalTo(self.username.mas_right).offset(padding);
    }];
}
-(void)createCommodityImage{
    [self.contentView addSubview: self.commodityImageV];
    [self.commodityImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.username);
//        make.bottom.equalTo(self.details);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.contentView.mas_right).offset(-padding);
        make.width.mas_equalTo(35);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createWithGrabButton:(void (^)(void))action{
    [_grabManagerBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.favicon);
        make.right.equalTo(self.contentView).offset(-padding);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(40);
    }];
    _grabManagerBt.layer.backgroundColor = Tint_COLOR.CGColor;
    _grabManagerBt.layer.cornerRadius = 2;
    [_grabManagerBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _grabManagerBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [_grabManagerBt setTitle:@"确定" forState:UIControlStateNormal];
    
    [_grabManagerBt handleControlEvent:UIControlEventTouchUpInside withBlock:action];
}

@end

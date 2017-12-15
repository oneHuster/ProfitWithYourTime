//
//  voucherCell.m
//  闲么
//
//  Created by 邹应天 on 16/2/13.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "voucherCell.h"
#import "NSString+timeFormat.h"
@interface voucherCell()
@property UIImageView *circleV;
@property UIImageView *priceV;
@property UILabel *freeWallet;
@property UILabel *time;
@property UILabel *money;
@end


@implementation voucherCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageV];

        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(90);
            make.right.equalTo(self.contentView.mas_right);
            make.left.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
        }];
        _isOpened = NO;
    }
    return self;
    
}
-(void)initWithUnopened{
    self.imageV.image = [UIImage imageNamed:@"钱包.png"];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1:)];
    [_imageV addGestureRecognizer:singleTap1];
    _imageV.userInteractionEnabled = YES;
    if (!self.circleV) {
        self.circleV = [UIImageView new];
        self.circleV.clipsToBounds = NO;
        [self.imageV addSubview:self.circleV];
        self.circleV.image = [UIImage imageNamed:@"circle.png"];
        [self.circleV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageV);
            make.height.mas_equalTo(48);
            make.width.mas_equalTo(48);
            make.top.mas_equalTo(13.5);
        }];
    }
    if (!_priceV) {
        self.priceV = [UIImageView new];
        self.priceV.image = [UIImage imageNamed:@"¥.png"];
        [self.circleV addSubview:self.priceV];
        [self.priceV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.circleV);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(28);
            make.top.mas_equalTo(10);
        }];
    }
    if (!_freeWallet) {
        self.freeWallet = [UILabel new];
        self.freeWallet.text = @"闲么红包";
        self.freeWallet.textColor = [UIColor whiteColor];
        self.freeWallet.font = [UIFont systemFontOfSize:10];
        [self.imageV addSubview:self.freeWallet];
        [self.freeWallet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.circleV.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self.imageV);
        }];
    }
}
-(void)initWithOpened{
    self.imageV.image = [UIImage imageNamed:@"打开钱包.png"];
    if (!_time) {
        self.time = [UILabel new];
        [self.imageV addSubview:self.time];
        self.time.textColor = [UIColor whiteColor];
        self.time.text = @"有效期至2016-12-31";
        self.time.font = [UIFont systemFontOfSize:10];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV).offset(15);
            make.bottom.equalTo(self.imageV).offset(-5);
            
        }];
    }
    if (!_priceV) {
        self.priceV = [UIImageView new];
        self.priceV.image = [UIImage imageNamed:@"unit.png"];
        [self.imageV addSubview:self.priceV];
        [self.priceV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageV).offset(-20);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(35);
            make.top.mas_equalTo(self.imageV).offset(15);
        }];
    }
    if (!_money) {
        _money   = [UILabel new];
        _money.textColor = [UIColor yellowColor];
        _money.font = [UIFont systemFontOfSize:45];
        [_imageV addSubview:_money];
    }
    [_money mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceV);
        make.left.equalTo(_priceV.mas_right).offset(10);
    }];
}
- (void)updateTheData:(NSDictionary *)dic{
    if (!self.isOpened) {
        [_time removeFromSuperview];
        [_priceV removeFromSuperview];
        [_money removeFromSuperview];
        _time  = nil;
        _priceV = nil;
        _money = nil;
        [self initWithUnopened];
        
        
    }
    else{
        [_freeWallet removeFromSuperview];
        [_circleV removeFromSuperview];
        [_priceV removeFromSuperview];
        _freeWallet = nil;
        _circleV = nil;
        _priceV  = nil;
        [self initWithOpened];
        //NSString *string =  dic[@"EndDate"];
        //_time.text = [NSString stringWithFormat:@"有效期至%@",        [NSString standardizeFormatToyyyymmdd:string]];
        _time.text =  dic[@"EndDate"];
        _money.text = [NSString stringWithFormat:@"%ld",[dic[@"Money"] integerValue]];
    }
}

- (void)buttonpress1:(UIGestureRecognizer*)tap{
    _isOpened = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openVoucher" object:self];
    [tap removeTarget:_imageV action:@selector(buttonpress1:)];
}

@end

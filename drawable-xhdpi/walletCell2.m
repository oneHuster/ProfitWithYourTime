//
//  walletCell2.m
//  闲么
//
//  Created by 邹应天 on 16/4/18.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "walletCell2.h"

@implementation walletCell2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _recharge = [UIButton new];
        [self.contentView addSubview:_recharge];
        [_recharge setTitle:@"充值" forState:UIControlStateNormal];
        [_recharge setTitleColor:Tint_COLOR forState:UIControlStateNormal];
        [_recharge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_centerX).offset(-30);
            make.leftMargin.mas_equalTo(30);
            make.height.mas_equalTo(self.contentView.mas_height).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        
        _withDraw = [UIButton new];
        [self.contentView addSubview:_withDraw];
        [_withDraw setTitle:@"提现" forState:UIControlStateNormal];
        [_withDraw setTitleColor:Tint_COLOR forState:UIControlStateNormal];
        [_withDraw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).offset(30);
            make.rightMargin.mas_equalTo(-30);
            make.height.mas_equalTo(self.contentView.mas_height).offset(-10);
            make.centerY.equalTo(self.contentView);
 
        }];
        
    }
    
    return self;
}
@end

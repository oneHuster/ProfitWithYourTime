//
//  detailContenAndNameCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/30.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "detailContenAndNameCell.h"

@implementation detailContenAndNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _title = [UILabel new];
        _title.textColor = Tint_COLOR;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(padding);
            make.left.equalTo(self.contentView).offset(padding);
            make.right.equalTo(self.contentView).offset(padding);
        }];
        
        _content = [UILabel new];
        _content.textColor = Font_COLOR;
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        [_content setNumberOfLines:0];
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(padding);
            make.top.mas_equalTo(_title.mas_bottom).offset(5);
            make.right.equalTo(self.contentView).offset(padding);
            make.bottom.equalTo(self.contentView).offset(-padding);
        }];
    }
    return self;
}
//- (void)setTitleText:(NSString*)title andContent:(NSString*)content{
//    
//}

@end

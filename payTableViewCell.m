//
//  payTableViewCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "payTableViewCell.h"

@implementation payTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = Font_COLOR;
        self.detailTextLabel.textColor = Font_COLOR;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}
@end

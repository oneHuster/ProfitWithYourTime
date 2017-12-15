//
//  headButton.m
//  闲么
//
//  Created by 邹应天 on 16/2/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "headButton.h"

@implementation headButton
-(id)initWithImage:(UIImage*)image andTitle:(NSString*)title{
    self = [super init];
    if (self) {
       // NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
        //NSArray *subviews = [[self.subviews objectAtIndex:0]subviews];
        
        self.imageV = [UIImageView new];
        self.imageV.image = image;
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-20);
        }];
        self.label = [UILabel new];
        self.label.text = title;
        self.label.textColor = [UIColor grayColor];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageV.mas_bottom);
            make.width.and.bottom.and.left.mas_equalTo(self);
        }];
    }
    return self;
}
@end

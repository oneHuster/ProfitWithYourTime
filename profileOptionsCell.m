//
//  profileOptionsCell.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "profileOptionsCell.h"

@implementation profileOptionsCell
-(void)createLabelWithText:(NSString*)string{
    if (!self.label) {
        self.label = [[UILabel alloc]init];
        //self.label.textColor = [UIColor grayColor];
        self.label.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.label];
    }
       self.label.text = string;
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.mas_left).offset(50);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}
-(void)createImageFlag:(UIImage*)image{
    if (!self.flagImage) {
        self.flagImage = [[UIImageView alloc]initWithImage:image];
        //设置图片原图适应imageview不做拉伸。
        self.flagImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.flagImage];

    }
    [self.flagImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.label.mas_left).offset(-8);
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
}
-(void)createFavicon:(UIImage *)image AndUserInfo:(NSDictionary*)diction{
    if (!self.username) {
        self.username = [[UILabel alloc]init];
        self.username.text =[diction objectForKey:@"username"];
        
        self.age = [[UILabel alloc]init];
        self.age.text = [diction objectForKey:@"age"];
        
        self.sexual = [[UIImageView alloc]init];
        if ([[diction objectForKey:@"sexual"] isEqualToString:@"male"]) {
            self.sexual.image = [UIImage imageNamed:@"male.png"];
        }
        self.favicon = [[UIButton alloc]init];
        self.favicon.layer.cornerRadius=25;
        self.favicon.layer.borderWidth=2;
        self.favicon.layer.masksToBounds=YES;
        self.favicon.layer.borderColor= [[UIColor colorWithWhite:0.8 alpha:0.5]CGColor];
        [self.favicon.layer setContents:(id)image.CGImage];
        
        [self addSubview:self.username];
        [self addSubview:self.age];
        [self addSubview:self.favicon];
        [self addSubview:self.sexual];
    }
    
  
    [self.favicon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

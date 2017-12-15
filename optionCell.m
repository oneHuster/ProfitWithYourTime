//
//  optionCell.m
//  闲么
//
//  Created by 邹应天 on 16/2/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "optionCell.h"
@interface optionCell()
@property UILabel *publishLabel;
@property UILabel *hotLabel;
@end
@implementation optionCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //self.textLabel.text = @"关山口男子职业技术学院";
        self.clipsToBounds = NO;
    }
    return self;
}
-(void)createWithModels{
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    self.imageV = [UIImageView new];
        [view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(view).offset(5);
        make.bottom.mas_equalTo(view).offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.imageV.layer.cornerRadius = 20;
    self.imageV.image = [UIImage imageNamed:@"关山口.png"];
    
    self.label = [UILabel new];
        [view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageV.mas_centerY).offset(5);
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
    }];
    self.label.text = @"关山口男子职业技术学院";
    
    self.publishLabel = [UILabel new];
    self.publishLabel.textColor = [UIColor grayColor];
        [view addSubview:self.publishLabel];
    [self.publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label);
        make.top.equalTo(self.imageV.mas_centerY).offset(5);
//        make.width.mas_equalTo(30);
    }];
    self.publishLabel.font = [UIFont systemFontOfSize:12];
    self.publishLabel.text = @"发布数";
    
    self.publishCountL = [UILabel new];
    self.publishCountL.textColor = Tint_COLOR;
    self.publishCountL.text = @"3020";
    self.publishCountL.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.publishCountL];
    [self.publishCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publishLabel.mas_right);
        make.centerY.equalTo(self.publishLabel);
//        make.width.mas_equalTo(30);
    }];
    
    
    self.hotLabel = [UILabel new];
    self.hotLabel.textColor = [UIColor grayColor];
        [view addSubview:self.hotLabel];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publishCountL.mas_right);
        make.top.equalTo(self.imageV.mas_centerY).offset(5);
        //make.width.mas_equalTo(30);
    }];
    self.hotLabel.font = [UIFont systemFontOfSize:12];
    self.hotLabel.text = @"人气";
    
    self.hotCountL = [UILabel new];
    self.hotCountL.textColor = Tint_COLOR;
    self.hotCountL.text = @"53020";
    self.hotCountL.font = [UIFont systemFontOfSize:12];
    [view addSubview:self.hotCountL];
    [self.hotCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotLabel.mas_right);
        make.centerY.equalTo(self.publishLabel);
        //make.width.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: view];
    
}
@end

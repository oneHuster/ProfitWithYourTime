//
//  MySearchBar.m
//  闲么
//
//  Created by 邹应天 on 16/1/26.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar
-(void)layoutSubviews{
    [super layoutSubviews];
    UITextField *searchField;
//    UIView *oneSubview;
    UIView *FirstSubview;
    UIButton *cancelButton;
    FirstSubview = [[self subviews]objectAtIndex:0];
    NSUInteger numViews = [[FirstSubview subviews] count];
    //NSLog(@"%@",);
    for(int i = 0; i < numViews; i++) {
        if([  [[FirstSubview subviews]objectAtIndex:i ] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [[FirstSubview subviews]objectAtIndex:i ];
        }
        if ([   [[FirstSubview subviews]objectAtIndex:i] isKindOfClass:[UIButton class] ]) {
            cancelButton = [[FirstSubview subviews]objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setTintColor:[UIColor whiteColor]];
        [searchField setTextColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 2;
        searchField.clipsToBounds = YES;
        searchField.placeholder = @"请输入关键词";
        
        
        cancelButton.backgroundColor = [UIColor orangeColor];
        cancelButton.layer.cornerRadius = 2;
        cancelButton.clipsToBounds = YES;
//        cancelButton.titleLabel.font = [UIFont systemFontOfSize:36];
        //只能强制用ios3的方法设置.
        [cancelButton setFont:[UIFont systemFontOfSize:12]];
        [cancelButton setTintColor:[UIColor whiteColor]];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FirstSubview).offset(-10);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(50);
            make.bottom.equalTo(FirstSubview).offset(-8);
        }];
        
//        [searchField mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//        }];
        [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(FirstSubview).offset(10);
            make.height.mas_equalTo(25);
            make.right.mas_equalTo(FirstSubview).offset(-5-10-50);
            make.bottom.equalTo(FirstSubview).offset(-8);

        }];

        
//        CGRect newFrame = CGRectMake(searchField.frame.origin.x, searchField.frame.origin.y+10, searchField.frame.size.width, searchField.frame.size.height);
//        [searchField setFrame:newFrame];
//        NSLog(@"%@",NSStringFromCGRect(searchField.frame));
        
    }
    
//    [self setBarTintColor:[UIColor whiteColor]];
    [self setBarStyle:UIBarStyleBlack];
}
@end

//
//  MaskView.m
//  闲么
//
//  Created by 邹应天 on 16/1/26.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
        
        UIView *mask_v = [UIView new];
        
        mask_v.backgroundColor = [UIColor whiteColor];
        [self addSubview:mask_v];
//        [UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-20, frame.size.width-20)
        [mask_v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(self.mas_width).offset(-20);
            make.height.mas_equalTo(self.mas_width).offset(-20);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
        mask_v.layer.cornerRadius = (frame.size.width-20)/2;
        mask_v.layer.shadowOffset = CGSizeMake(0, 0);
        mask_v.layer.shadowColor = [UIColor grayColor].CGColor;
        mask_v.layer.shadowOpacity = 1;
        mask_v.layer.shadowRadius = 2;

//        mask_v.center.x = self.center.x;
       
        //mask_v.alpha = 0.5;
        UIButton *button = [UIButton new];
        
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(2, 2,mask_v.frame.size.width-4, mask_v.frame.size.height-4)];
                [mask_v addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(mask_v.mas_centerX);
                    make.centerY.mas_equalTo(mask_v.mas_centerY);
                    make.width.mas_equalTo(mask_v.mas_width).offset(-4);
                    make.height.mas_equalTo(mask_v.mas_width).offset(-4);
                }];
                button.layer.cornerRadius = (frame.size.width-24)/2;
                button.layer.masksToBounds = YES;
                button.layer.backgroundColor = Tint_COLOR.CGColor;
                [button addTarget:self action:@selector(selectedAddButton:) forControlEvents:UIControlEventTouchDown];
        
    }
    return self;
}

-(void)selectedAddButton:(id)sender{
      [[NSNotificationCenter defaultCenter]postNotificationName:@"addButton" object:sender];
    //NSLog(@"send to notificationcenter");
//    if (self.selectedAddButton) {
//        self.selectedAddButton(entity);
//    }
}
@end

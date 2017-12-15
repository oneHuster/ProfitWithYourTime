//
//  imageDisplayCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "imageDisplayCell.h"

@implementation imageDisplayCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _imageV = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageV];
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
   
    return self;
}
- (void)removeTheButton{
    if (_button) {
        [_button removeFromSuperview];
        _button = nil;
    }
}

- (void)addTheButton{
    if (!_button){
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        [_button setImage:[UIImage imageNamed:@"cancelImage"] forState:UIControlStateNormal];
        _button.center = self.contentView.frame.origin;
        [self.contentView addSubview:_button];
    }
}
@end

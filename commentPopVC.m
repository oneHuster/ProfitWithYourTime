//
//  commentPopVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/11.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "commentPopVC.h"
#import <STPopup.h>
#import "ZYTTextField.h"
#import "NetWorkingObj.h"
@interface commentPopVC()
@property ZYTTextField *textfield;

@end
@implementation commentPopVC
- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"评论";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
        [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
        [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18], NSForegroundColorAttributeName: [UIColor whiteColor] };

        self.contentSizeInPopup = CGSizeMake(300, 100);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textfield = [[ZYTTextField alloc]initWithFrame:self.view.bounds];
    _textfield.placeholder  = @"请输入评论信息";
    [self.view addSubview: _textfield];
    // Add views here
    // self.view.frame.size == self.contentSizeInPopup in portrait
    // self.view.frame.size == self.landscapeContentSizeInPopup in landscape
}
- (void)nextBtnDidTap{
    if ([_textfield.text length]>0) {
        NetWorkingObj *networking = [NetWorkingObj shareInstance];
        [networking addCommentToOrder:_orderModel];
        [self.popupController dismiss];
    }
}

@end

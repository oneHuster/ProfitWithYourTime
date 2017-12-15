//
//  confirmPopVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "confirmPopVC.h"
#import <STPopup/STPopup.h>
@implementation confirmPopVC

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"接单确认";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定接单" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add views here
    // self.view.frame.size == self.contentSizeInPopup in portrait
    // self.view.frame.size == self.landscapeContentSizeInPopup in landscape
}
- (void)nextBtnDidTap{
    
}
@end

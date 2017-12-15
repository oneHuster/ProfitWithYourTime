//
//  profileVC.h
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profileVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property UITableView *tableview;
@property NSMutableArray *backGrounds;
@property NSArray *flagImages;
@property NSArray *itemsText;

@property UIButton *loginButton;
@property UIButton *registerButton;
@end

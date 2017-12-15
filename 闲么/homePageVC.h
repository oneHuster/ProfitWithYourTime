//
//  homePageVC.h
//  闲么
//
//  Created by 邹应天 on 16/1/21.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
//#import "homeMainbodyCell.h"
#import "MySearchBar.h"
@class  SDCycleScrollView;
@interface homePageVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property UITableView *tableView;
@property UIButton *searchbar;
@property UIButton *searchBarButton;
//@property UILabel *citySelector;
@property UIButton *adminFavicon;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end

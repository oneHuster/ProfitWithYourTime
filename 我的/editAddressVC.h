//
//  editAddressVC.h
//  闲么
//
//  Created by 邹应天 on 16/4/10.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol editAddressDelegate <NSObject>

@optional
- (void)HaveFinishedSavingAddress:(NSDictionary*)dic;

@end

@interface editAddressVC : UITableViewController

@property (nonatomic) NSMutableDictionary *infodic;
@property bool isNew;
@property NSInteger tag;
@property (nonatomic,weak)id<editAddressDelegate>delegate;

@end

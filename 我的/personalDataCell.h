//
//  personalDataCell.h
//  闲么
//
//  Created by 邹应天 on 16/3/22.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalDataCell : UITableViewCell

/*whoes inputview is readwrite*/
@property UITextField *content;

- (void)loadModelWithTitle:(NSString*)string AndItem:(NSString*)content;
- (void)createTextField;
@end

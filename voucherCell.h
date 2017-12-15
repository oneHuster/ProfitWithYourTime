//
//  voucherCell.h
//  闲么
//
//  Created by 邹应天 on 16/2/13.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface voucherCell : UITableViewCell
@property UIImageView *imageV;
@property BOOL isOpened;
- (void)updateTheData:(NSDictionary*)dic;
@end

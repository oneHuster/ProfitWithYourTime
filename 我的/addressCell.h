//
//  addressCell.h
//  闲么
//
//  Created by 邹应天 on 16/4/9.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addressCell : UITableViewCell
@property UILabel *nickname;
@property UILabel *phone;
@property UILabel *detail;

- (void)updateWithModel:(NSDictionary*)dic;
@end

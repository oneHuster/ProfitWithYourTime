//
//  messageTableViewCell.h
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageTableViewCell : UITableViewCell

- (void)updateWithIcon:(UIImage*)icon AndTitle:(NSString*)title AndDetailInfo:(NSString*)info and:(BOOL)newMessage;

@property UIImageView *redDotV;
@property UIImageView *flagImage;
@property UILabel *label;
@property UILabel *detailInfoLb;


@end

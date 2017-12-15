//
//  messageCell.h
//  闲么
//
//  Created by 邹应天 on 16/1/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderMdl.h"
#import "receiveMdl.h"
@interface messageCell : UITableViewCell

@property UIButton *grabManagerBt;
- (void)initWithModel:(orderMdl*)model;
- (void)initWithReceiver:(receiveMdl*)receiver;
- (void)createWithGrabButton:(void (^)(void))action;
@end

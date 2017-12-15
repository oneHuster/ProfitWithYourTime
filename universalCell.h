//
//  universalCell.h
//  闲么
//
//  Created by 邹应天 on 16/1/27.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderMdl.h"
@interface universalCell : UITableViewCell

//@property NSString *content;
@property UILabel *username;
@property UILabel *publishTime;
@property UILabel *price;
@property UIToolbar *toolBar;
@property NSMutableArray *imageArray;
@property UIView *nineGridV;
@property UIImageView *favicon;

@property UILabel *title;
@property UILabel *content;
@property UIButton *location;
@property UIButton *praise;
@property UIButton *comment;
@property UIButton *grabOrder;
-(void)updateWithModel:(orderMdl*)model;
//+ (CGFloat)heightWithModel:(cellModel*)cellModel;
-(void)addTheGrabOrder:(void (^)(void))action;

- (void)addThePraised:(void (^)(void))action;
- (void)addTheComment:(void (^)(void))action;
//pre calculate height
- (void)configureCellWithModel:(orderMdl*)model;
@end

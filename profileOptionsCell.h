//
//  profileOptionsCell.h
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profileOptionsCell : UITableViewCell


-(void)createImageFlag:(UIImage*)image;
-(void)createLabelWithText:(NSString*)string;
-(void)createFavicon:(UIImage*)image AndUserInfo:(NSDictionary*)diction;
@property UIImageView *flagImage;
@property UILabel *label;
//info
@property UIButton *favicon;
@property UILabel *username;
@property UIImageView *sexual;
@property UILabel *age;
@end

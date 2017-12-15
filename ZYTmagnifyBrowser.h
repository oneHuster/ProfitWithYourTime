//
//  ZYTmagnifyBrowser.h
//  weibo
//
//  Created by 邹应天 on 15/12/5.
//  Copyright © 2015年 邹应天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYTmagnifyBrowser : UIScrollView <UIActionSheetDelegate>
-(void)showImage:(UIImageView*)imageView;
@property UIImageView *myImageView;
//- (instancetype)initWithImage:(UIImageView *)image;
@end

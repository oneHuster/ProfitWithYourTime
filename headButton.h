//
//  headButton.h
//  闲么
//
//  Created by 邹应天 on 16/2/28.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headButton : UIButton
-(id)initWithImage:(UIImage*)image andTitle:(NSString*)title;
@property UIImageView *imageV;
@property UILabel *label;
@end

//
//  commentMdl.h
//  闲么
//
//  Created by 邹应天 on 16/3/2.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentMdl : NSObject
@property long time;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *name;
@property int sex;
@property (nonatomic,copy)NSString *toCommentPhone;
@property (nonatomic,copy)NSString *commentContent;
@end

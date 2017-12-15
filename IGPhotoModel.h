//
//  IGPhotoModel.h
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface IGPhotoModel : NSObject

@property (nonatomic,strong) PHAsset *asset;

@property (nonatomic,assign,setter=setSelected:) BOOL isSelected;

@property (nonatomic)UIImage *Image;
+ (instancetype)modelWithAsset:(PHAsset *)asset;
- (UIImage*)getSelectedImage;
@end

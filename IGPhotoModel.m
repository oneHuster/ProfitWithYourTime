//
//  IGPhotoModel.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGPhotoModel.h"

@implementation IGPhotoModel

+ (instancetype)modelWithAsset:(PHAsset *)asset
{
    IGPhotoModel *model = [[self alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    return model;
}

//- (UIImage*)getSelectedImage{
//    return aimage;
//}
@end

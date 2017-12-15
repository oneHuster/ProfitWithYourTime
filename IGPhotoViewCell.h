//
//  IGPhotoViewCell.h
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IGPhotoModel.h"

@interface IGPhotoViewCell : UICollectionViewCell


@property (nonatomic,strong) IGPhotoModel *model;

@property (nonatomic,copy,setter=tapPhotoSelectedView:) void(^tapPhotoSelectedView)(IGPhotoModel *model);


- (void)tapPhotoSelectedView:(void (^)(IGPhotoModel *model))tapPhotoSelectedView;

+ (instancetype)photoViewCellWithCollectionView:(UICollectionView *)collectoinView forIndexPath:(NSIndexPath *)indexPath;

@end

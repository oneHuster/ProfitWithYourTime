//
//  IGFullScreenPhotoViewCell.h
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface IGFullScreenPhotoViewCell : UICollectionViewCell

@property (nonatomic,strong) PHAsset *asset;

+ (instancetype)fullScreenPhotoViewCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

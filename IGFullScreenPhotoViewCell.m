//
//  IGFullScreenPhotoViewCell.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGFullScreenPhotoViewCell.h"


@interface IGFullScreenPhotoViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageHeight;


@end

@implementation IGFullScreenPhotoViewCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor blackColor];
}

+ (instancetype)fullScreenPhotoViewCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([self class]);
    [collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
    return [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    
    CGFloat height = asset.pixelHeight / (asset.pixelWidth / [UIScreen mainScreen].bounds.size.width);
    _photoImageHeight.constant = height;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager  defaultManager] requestImageForAsset:asset targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, height) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *  result, NSDictionary * info) {
        
        _photoImageView.image = result;
        
    }];
}



@end

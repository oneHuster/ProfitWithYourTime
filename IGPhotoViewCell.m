//
//  IGPhotoViewCell.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//


#import "IGPhotoViewCell.h"
#import <Photos/Photos.h>

@interface IGPhotoViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flagView;

@end

@implementation IGPhotoViewCell


- (void)awakeFromNib
{
    _flagView.userInteractionEnabled = YES;
    [_flagView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFlagView:)]];
}

+ (instancetype)photoViewCellWithCollectionView:(UICollectionView *)collectoinView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([self class]);
    
    [collectoinView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
    
    return [collectoinView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
}

- (void)setModel:(IGPhotoModel *)model
{
    _model = model;
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(120.0, 120.0) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * result, NSDictionary * info) {
        _photoImageView.image = result;
        
    }];
    
    NSString *imageName = model.isSelected ? @"selected_flag" : @"unselected_flag";
    
    _flagView.image = [UIImage imageNamed:imageName];
}

- (void)tapFlagView:(UITapGestureRecognizer *)tap
{
    _model.isSelected = !_model.isSelected;
    
    NSString *imageName = _model.isSelected ? @"selected_flag" : @"unselected_flag";
    
    _flagView.image = [UIImage imageNamed:imageName];
    
    if (_tapPhotoSelectedView) {
        _tapPhotoSelectedView(_model);
    }
    
}


@end

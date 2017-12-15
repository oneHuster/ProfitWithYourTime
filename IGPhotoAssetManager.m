//
//  IGPhotoAssetManager.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGPhotoAssetManager.h"


#import <Photos/Photos.h>
#import "IGPhotoModel.h"


@interface IGPhotoAssetManager()


@end

@implementation IGPhotoAssetManager


+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static IGPhotoAssetManager *sharedManager;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
        sharedManager.selectedPhotos = [NSMutableOrderedSet orderedSet];
    });
    
    return sharedManager;
}

- (NSMutableArray *)photos
{
    
    if (_photos == nil || _photos.count == 0) {
        _photos = [NSMutableArray array];
        
        PHFetchOptions *options = [[PHFetchOptions alloc]init];
        // 按创建时间降序排列
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
        
        for (PHAsset *asset in result) {
            
            IGPhotoModel *model = [IGPhotoModel modelWithAsset:asset];
            [_photos addObject:model];
        }
        
    }
    return _photos;
}




@end

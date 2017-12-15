//
//  IGPhotoAssetManager.h
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
  这个类用来读取相册中的照片和相簿信息，然后提供接口给外接使用
 */

@interface IGPhotoAssetManager : NSObject

@property (nonatomic,strong) NSMutableArray *photos;

@property (nonatomic,strong) NSMutableOrderedSet *selectedPhotos;


+ (instancetype)sharedManager;


@end

//
//  IGPhotoPickerViewController.h
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGPhotoPickerViewController : UINavigationController

@property (nonatomic,copy,setter=completePickingPhotos:) void(^completePickingPhotos)(NSMutableOrderedSet *selectedPhotos);

- (void)completePickingPhotos:(void (^)(NSMutableOrderedSet *))completePickingPhotos;

@end

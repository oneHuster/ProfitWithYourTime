//
//  IGPhotoPickerViewController.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/11/3.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGPhotoPickerViewController.h"
#import "IGPhotoListViewController.h"
#import "IGPhotoAssetManager.h"

@interface IGPhotoPickerViewController ()

@end

@implementation IGPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IGPhotoListViewController * plvc = [[IGPhotoListViewController alloc]init];
    
    self.viewControllers = @[plvc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCompletePickingPhotosNotification:) name:@"CompletePickingPhotosNotification" object:nil];
}

- (void)receiveCompletePickingPhotosNotification:(NSNotification *)notification
{
    _completePickingPhotos(notification.userInfo[@"selectedPhotos"]);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[[IGPhotoAssetManager sharedManager] photos] removeAllObjects];
        [[[IGPhotoAssetManager sharedManager] selectedPhotos] removeAllObjects];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

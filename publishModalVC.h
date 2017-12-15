//
//  publishModalVC.h
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYTTextField.h"
#import "ZYTShadowView.h"
#import  <AVFoundation/AVFoundation.h>
#import "RITPopoverSlider.h"

@interface publishModalVC : UIViewController<AVAudioRecorderDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *navigation_view;
@property (strong, nonatomic) IBOutlet UIView *imageDiplayV;
@property (strong, nonatomic) IBOutlet ZYTTextField *desField;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionV;
@property (strong, nonatomic) IBOutlet ZYTTextField *principalField;
@property (strong, nonatomic) IBOutlet ZYTTextField *titleField;
@property (strong, nonatomic) IBOutlet ZYTTextField *adressFiled;
@property (strong, nonatomic) IBOutlet ZYTTextField *timeField;
@property (strong, nonatomic) IBOutlet UIButton *backBarItem;
@property (strong, nonatomic) IBOutlet UIButton *cancelSpeak;
@property (strong, nonatomic) IBOutlet UIButton *backToSpeak;

@property (strong, nonatomic) IBOutlet UIButton *speechButton;
@property (strong, nonatomic) IBOutlet UIButton *publishButton;
@property (strong, nonatomic) IBOutlet RITPopoverSlider *tipSlider;

@end

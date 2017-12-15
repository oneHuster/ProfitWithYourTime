//
//  publishModalVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/25.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "publishModalVC.h"
#import "NSString+getDeviceModel.h"
#import "orderMdl.h"
#import "NetWorkingObj.h"
#import "payVC.h"
#import <BMKGeocodeSearch.h>
#import "transferVC.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "IGPhotoPickerViewController.h"
#import "IGPhotoAssetManager.h"
#import "IGPhotoModel.h"
#import "imageDisplayCell.h"
#import "popupV.h"
#import "NSString+timeFormat.h"

static NSString * publishCollectionId = @"GradientCell";


@interface publishModalVC()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NetWorkingDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    UIButton *flagLabel;
    UIButton *locationBt;
    UILabel *locationLb;
}
@property UIDatePicker *datePickview;
@property  UIButton *backButton;
//@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
//@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
//@property UIPickerView *pickview;
@property ZYTAudioRecorder *audioRecorder;
@property AVAudioPlayer *audioButton;
@property orderMdl *model;
@property NSDate *receiveDate;
@property NSMutableArray<UIImage*> *currentImages;
@property NSMutableArray *imageUrlArray;
@property (strong,nonatomic) ZYTAudioVolumeBlock aVolumeBlock;
@end


@implementation publishModalVC
//对iphone4做专门的适配
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ([UIScreen mainScreen].bounds.size.height<481) {
        self = [super initWithNibName:@"publishVC_iphone4" bundle:nibBundleOrNil];
    }
    else
        self = [super initWithNibName:@"publishModalVC" bundle:nibBundleOrNil];
    return self;
}
-(void)viewDidLoad{
    self .view .backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    self.navigationItem.title = @"发布";
    [self.view addSubview:self.navigation_view];

    [self initWithBackButton];
    [self initWithImageDisplayView];
    [self initWithTextFields];
    [self initPressedToRecordingSpeech];
    [self initWithSpeechButton];
    [self setAudioSession];
    [self initWithPickView];
    [self initWithPublishButton];
    [self initWithLocationButton];

    
}

-(void)viewWillAppear:(BOOL)animated{
    _model = [[orderMdl alloc]init];
    _backButton.hidden = NO; 
    BaiduMapC *location = [BaiduMapC getTheBDMManager];
    [location startLocationServer];
    //[location locationWithAddress];
    _imageUrlArray = [NSMutableArray array];
}

//- (void)viewDidAppear:(BOOL)animated{
//    BaiduMapC *location = [BaiduMapC getTheBDMManager];
//    locationLb.text = location.address;
//}

- (void)locationIsRequired{
    BaiduMapC *location = [BaiduMapC getTheBDMManager];
    locationLb.text = location.address;
}

- (void)initWithBackButton{
//    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"backItem"]];
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backButton setImage:[UIImage imageNamed:@"backItem"] forState:UIControlStateNormal];
    _backButton.tintColor = [UIColor whiteColor];
    _backButton.contentMode = UIViewContentModeScaleAspectFit;
    [_backButton addTarget:self action:@selector(backTohomepage) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:_backButton];
}


- (void)initWithPickView{
    _datePickview = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2+70, SCREEN_WIDTH, SCREEN_HEIGHT/2-70)];
    _datePickview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_datePickview addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
    self.timeField.inputView = _datePickview;
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    _datePickview.locale = locale;
    
    
    //当前时间创建NSDate
    NSDate *localDate = [NSDate date];
    //在当前时间加上的时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //设置时间
    [offsetComponents setYear:0];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:5];
    [offsetComponents setHour:20];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    //设置最大值时间
    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:localDate options:0];
    //设置属性
    _datePickview.minimumDate = localDate;
    _datePickview.maximumDate = maxDate;
}

-(void)initWithSpeechButton{
    [self.speechButton addTarget:self action:@selector(isrecordingSpeech) forControlEvents:UIControlEventTouchDown];
    [self.speechButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initWithPublishButton{
    _publishButton.layer.cornerRadius = 3;
}
-(void)initWithImageDisplayView{
   // NSString * strModel  = [UIDevice currentDevice].model;
//    if (IS_IPHONE_4_OR_LESS) {
//        NSLog(@"iphone 4");
//    }
    
    
    _currentImages = [[NSMutableArray alloc]init];
    [_currentImages addObject:[UIImage imageNamed:@"add"]];
    NSLog(@"%ld", (unsigned long)_currentImages.count);
    
    self.imageDiplayV.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageDiplayV.layer.shadowOpacity = 0.5;
    self.imageDiplayV.layer.shadowRadius = 2;
    self.imageDiplayV.layer.shadowOffset = CGSizeMake(0, 0);
   
    _imageCollectionV.backgroundColor = [UIColor whiteColor];
    _imageCollectionV.dataSource = self;
    _imageCollectionV.delegate = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //[flowLayout setItemSize:CGSizeMake(60, 60)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    [_imageCollectionV setCollectionViewLayout:flowLayout];
    [_imageCollectionV registerClass:[imageDisplayCell class] forCellWithReuseIdentifier:publishCollectionId];

}
- (void)initWithLocationButton{
    locationBt = [UIButton new];
    [_imageDiplayV addSubview:locationBt];
    [locationBt setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locationBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(15);
        make.leadingMargin.mas_equalTo(padding);
        make.bottom.equalTo(_imageDiplayV.mas_bottom).offset(-padding);
    }];
    [locationBt addTarget:self action:@selector(locationIsRequired) forControlEvents:UIControlEventTouchUpInside];
    
    locationLb = [UILabel new];
    locationLb.text = @"武汉华科";
    locationLb.font = [UIFont systemFontOfSize:10];
    [_imageDiplayV addSubview:locationLb];
    [locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationBt.mas_right).offset(10);
        make.centerY.equalTo(locationBt);
        make.height.equalTo(locationBt);
    }];
}
-(void)initWithTextFields{
    _desField.placeholder = @"输入订单描述";
    _desField.clipsToBounds = YES;
    _desField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;

    
    self.principalField.placeholder = @"请输入本金";
    //_principalField.delegate = self;
    _principalField.keyboardType = UIKeyboardTypeNumberPad;
    self.adressFiled.placeholder =@"请输入收货地址";
    self.timeField.placeholder = @"请输入收货时间";
    _timeField.delegate = self;
    _adressFiled.delegate = self;
    flagLabel = [UIButton new];
    [flagLabel setTitle:@"常用" forState:UIControlStateNormal];
    flagLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [flagLabel setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    flagLabel.titleLabel.font = [UIFont systemFontOfSize:10];
    flagLabel.layer.cornerRadius = 3;
    flagLabel.layer.backgroundColor = Tint_COLOR.CGColor;
    [self.adressFiled addSubview:flagLabel];
    [flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.adressFiled.mas_right).offset(-8);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.adressFiled.mas_centerY);
    }];
    
}
//取消说话按钮
-(void)initPressedToRecordingSpeech{
    [self.cancelSpeak setTintColor:[UIColor whiteColor]];
    [self.cancelSpeak setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.cancelSpeak  setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [self.cancelSpeak addTarget: self action:@selector(cancelSpeakButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    self.titleField.placeholder = @"请输入标题";
    self.titleField.alpha = 0;
    [self.view insertSubview:self.titleField belowSubview:self.speechButton];
    
    //继续去发语音按钮
    self.backToSpeak.alpha = 0;
    [self.backToSpeak addTarget:self action:@selector(backToSpeakButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.backToSpeak setTintColor:Tint_COLOR];
    [self.backToSpeak setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.backToSpeak  setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [self.view insertSubview:self.backToSpeak belowSubview:self.speechButton];

}

-(void)backTohomepage{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"disPublishButton" object:nil];
}


#pragma mark -------------------------------textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField == _timeField) {
            self.view.transform = CGAffineTransformMakeTranslation(0, -30*2-padding);
        }
        else if (textField == _adressFiled)
            self.view.transform = CGAffineTransformMakeTranslation(0,-30);
        
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField == _timeField) {
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }
        else if (textField == _adressFiled)
            self.view.transform = CGAffineTransformMakeTranslation(0,0);
        
    }];

}
#pragma mark ----------------------------------pickview selector
- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    _receiveDate = control.date;
    //添加你自己响应代码
    //NSLog(@"dateChanged响应事件：%@",date);
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [_datePickview date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日(EEEE)   HH:mm:ss"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //打印显示日期时间
    NSLog(@"格式化显示时间：%@",dateString);
    self.timeField.text = dateString;
}
#pragma mark -----------------------------------collectionV delegate
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    imageDisplayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:publishCollectionId forIndexPath:indexPath];
   
//    UICollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
//    if (addCell == nil) {
//        addCell = [[UICollectionViewCell alloc]init];
//        UIImageView *imageV = [[UIImageView alloc]init];
//        imageV.image = [UIImage imageNamed:@"add"];
//    }
    
     NSUInteger count = self.currentImages.count-1;
     cell.imageV.image = [self.currentImages objectAtIndex:(count-indexPath.row)];
    
    if (indexPath.row == self.currentImages.count-1) {
        [cell removeTheButton];
    }else{
        [cell addTheButton];
        cell.button.tag = count-indexPath.row;
        [cell.button addTarget:self action:@selector(cancelAddImage:) forControlEvents:UIControlEventTouchDown];
    }
    return cell;
}

//取消添加图片
- (void)cancelAddImage:(UIButton*)sender{
   // NSLog(@"%ld",sender.tag);
    [self.currentImages removeObjectAtIndex:sender.tag];
    [_imageCollectionV reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_currentImages.count-1)
    {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从摄像头选取", @"从图片库选择",nil];
        [action showInView:self.view];
    }
    else
    {
//        [YSYPreviewViewController setPreviewImage:currentImages[indexPath.row]];
        //[self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PreviewVC"] animated:YES];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.currentImages.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义每个image大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark -----------------------------------actionSeet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//摄像头
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }else if(buttonIndex == 1){
        IGPhotoPickerViewController *ppvc = [[IGPhotoPickerViewController alloc]init];
        
        [ppvc completePickingPhotos:^(NSMutableOrderedSet *selectedPhotos) {
            
            

            //NSLog(@"已经选择的图片 -- %@",selectedPhotos);
            for (IGPhotoModel *model in selectedPhotos) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                //__block UIImage *aimage;
                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                    
                    [_currentImages addObject:result];
                    [self.imageCollectionV reloadData];
                    //上传图片
                    NetWorkingObj *netobj = [NetWorkingObj shareInstance];
                    netobj.delegate = self;
                    
                    [netobj upLoadImages:[UIImage imageWithCGImage:[result CGImage]]];
                }];
                
            }
            
        }];
        [self presentViewController:ppvc animated:YES completion:nil];
    }
}
#pragma mark -----------------------------------camera
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}



#pragma mark -----------------------------------Audio Set

/**
 *  设置音频会话
 */
-(void)setAudioSession{
    self.audioRecorder  =   [[ZYTAudioRecorder alloc]init];
    [self.audioRecorder audioInit];
}

//正在录音（按钮按下）
-(void)isrecordingSpeech{
    [self.audioRecorder startAudioRecording];
    //block传回音量大小.
    [self.audioRecorder setVolumeBlock:^(CGFloat volume){
        NSLog(@"volume:%f",volume);
    }];
}
//取消录音
-(void)stopClick:(UIButton *)sender {

    NSLog(@"%f",[self.audioRecorder getAudioRecordTime]);
    [self.audioRecorder stopAudioRecording];
    self.speechButton.enabled  =  NO;
    
    //[self.speechButton removeFromSuperview];
}
-(void)addtheAudioButton{
    
}



/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
//-(NSURL *)getSavePath{
//    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
//    NSLog(@"file path:%@",urlStr);
//    NSURL *url=[NSURL fileURLWithPath:urlStr];
//    return url;
//}

//取消录音发布
-(void)cancelSpeakButtonPressed{
    [self.view insertSubview:self.titleField aboveSubview:self.cancelSpeak];
    [self.view insertSubview:self.backToSpeak aboveSubview:self.titleField];
    [UIView animateWithDuration:0.6 animations:^{
        self.titleField.alpha = 1;
        self.backToSpeak.alpha = 1;
    }];
}
//继续去发语音
- (void)backToSpeakButtonPressed:(UIButton*)button{
    
    [UIView animateWithDuration:0.6 animations:^{
        self.titleField.alpha = 0;
        self.backToSpeak.alpha = 0;
    }completion:^(BOOL finished) {
        [self.view insertSubview:self.titleField belowSubview:self.speechButton];
        [self.view insertSubview:self.titleField belowSubview:self.speechButton];
    }];
}

- (void)NetWorkingFinishedLoadImages:(NSString *)ImageUrl{
    [_imageUrlArray addObject:ImageUrl];
}

-(IBAction)publishButtonPressed:(id)sender{
    
//    if ([self.titleField.text length]>0 && [self.adressFiled.text length]>0 && [self.timeField.text length]>0 && [self.principalField.text length]>0 && [self.desField.text length]>0) {
//        NetWorkingObj *netobj = [NetWorkingObj shareInstance];
//        _model.title = self.titleField.text;
//        _model.address = self.adressFiled.text;
//        _model.money = [self.principalField.text integerValue];
//        
//        _model.des = self.desField.text;
//        _model.orderName = @"";
//        _model.tip = _tipSlider.popupView.value;
//    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //    NSString *string = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
//    //    [dateFormatter setDateFormat:@"HH:mm:ss"];
//        //_model.receiveTime = [NSString stringWithFormat:@"%@T%@",string,[dateFormatter stringFromDate:[NSDate date]]];
//        //_model.receiveTime = [dateFormatter stringFromDate:[NSDate date]];
//        _model.iMgs = _imageUrlArray;
//        _model.province = @"";
//        _model.city = @"";
//        _model.dis = @"";
//        BaiduMapC *location = [BaiduMapC getTheBDMManager];
//        NSLog(@"%@",location.address);
//    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:1000];
////        NSTimeInterval a=[_receiveDate timeIntervalSince1970];
////        NSString *timestamp = [NSString stringWithFormat:@"%.0f", a];
////        _model.receiveTime = timestamp;
//        //NSDate *nowTime = ;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//       
//        _model.receiveTime = [NSString stringWithFormat:@"%.0f", [_receiveDate timeIntervalSince1970]];
//       
//        
//        
//        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//        _model.orderName = [NSString stringWithFormat:@"%@%d",[dateFormatter stringFromDate:[NSDate date]],rand()%8999+1000];
//        
//        [netobj publishOrderToServer:_model];
//
//        //[netobj upLoadImages:[NSArray array]];
//
//        //跳转到支付页面
//       
//    }else{
//        popupV *popupv = [popupV initWithWarning:nil];
//        [self.view addSubview:popupv];
//        [popupv animationPresentAfterTimeInterval:0 AndDelay:4];
//
//    }
//    payVC *payvc = [[payVC alloc]init];
//    payvc.tip = _model.tip;
//    payvc.money = _model.money;
//    payvc.orderId = _model.orderName;
    transferVC *transfer = [[transferVC alloc]init];
    _backButton.hidden = YES;
    [self.navigationController pushViewController:transfer animated:YES];
    
}

@end

//
//  adminSettingVC.m
//  闲么
//
//  Created by 邹应天 on 16/4/19.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

//
//  settingVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/22.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "adminSettingVC.h"
#import "personalDataCell.h"
#import "UserMdl.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetWorkingObj.h"
#import "UserMdl.h"
#import "NSString+timeFormat.h"
#import "loginRegisterVC.h"
#import "modifyPasswordVC.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface adminSettingVC()<UITableViewDataSource,UITableViewDelegate,VPImageCropperDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    NSArray *titleList;
    NSMutableArray *modelList;
}
@property UITableView *tableview;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property UIPickerView *pickView;
@property (copy)NSString *tempContent;
@end

static NSString *cellId = @"settingCellId";
@implementation adminSettingVC
- (void)viewDidLoad{
    self.navigationItem.title = @"我的资料";
    //若要做头像默认化
    //_portraitImageView.image = [UIImage imageNamed:@"favicon"];
    modelList = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"favicon"],@"未填写",@"未填写",@"未填写",@"这家伙很懒什么都没有留下", nil];
    self.navigationController.delegate = self;
    [self createPersonalTableView];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self loadDataWithModel];
    UserMdl *currentUser = [UserMdl getCurrentUserMdl];
    if (currentUser.sex==0)
        [modelList replaceObjectAtIndex:1 withObject:@"男"];
    else
        [modelList replaceObjectAtIndex:1 withObject:@"女"];
    //    if (currentUser.birthDay)
    //        [modelList replaceObjectAtIndex:2 withObject:currentUser.birthDay];
    if (currentUser.HomePlace)
        [modelList replaceObjectAtIndex:3 withObject:currentUser.HomePlace];
    if (currentUser.myWords)
        [modelList replaceObjectAtIndex:4 withObject:currentUser.myWords];
    [_tableview reloadData];
}

#pragma mark ----------------navigationcontroller delegate
//- (void)backButtonAction:(id)sender{
//
//}
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        UserMdl *currentuser = [UserMdl getCurrentUserMdl];
        currentuser.sex = [modelList[1]integerValue];
        currentuser.age = [modelList[2]integerValue];
        currentuser.myWords = modelList[4];
        NetWorkingObj *netObj = [NetWorkingObj shareInstance];
        [netObj userModifyProfile];
        if (_portraitImageView.image)
            [netObj upLoadfavicon:_portraitImageView.image];
        
    }
    [super viewWillDisappear:animated];
    
}

- (void)loadDataWithModel{
    UserMdl *currentUser = [UserMdl getCurrentUserMdl];
    if (currentUser.smallIconUrl) {
        [modelList replaceObjectAtIndex:0 withObject:currentUser.smallIconUrl];
    }
    if ([NSNumber numberWithInteger:currentUser.sex]) {
        if (currentUser.sex == 0) {
            [modelList replaceObjectAtIndex:1 withObject:@"男"];
        }else
            [modelList replaceObjectAtIndex:1 withObject:@"女"];
    }
    //    if ([NSNumber numberWithInteger:currentUser.birthDay]) {
    //        [modelList replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"",currentUser.birthDay]];
    //    }
    if (currentUser.HomePlace) {
        [modelList replaceObjectAtIndex:3 withObject:currentUser.HomePlace];
    }
    if (currentUser.myWords) {
        [modelList replaceObjectAtIndex:4 withObject:currentUser.myWords];
    }
}
- (void)createPersonalTableView{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableview registerClass:[personalDataCell class] forCellReuseIdentifier:cellId];
    _tableview.backgroundColor = V_COLOR;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 15)];
    [_tableview setSeparatorColor:V_COLOR];
    [self.view addSubview:_tableview];
    titleList = @[@"头像",@"性别",@"生日",@"常住",@"个人签名",@"修改密码",@"注销账户"];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag==1)
        return 2;
    else
        return 3;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *sexarray = @[@"男",@"女"];
    if (pickerView.tag == 1)
        return sexarray[row];
    else return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *sexarray = @[@"男",@"女"];
    if (pickerView.tag == 1)
        _tempContent = sexarray[row];
}

#pragma mark--- tableview delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tag = indexPath.row+indexPath.section;
    personalDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.portraitImageView];
        [self.portraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(50);
        }];
        [cell loadModelWithTitle:titleList[indexPath.row] AndItem:modelList[indexPath.row]];
    }else if(indexPath.section == 1){
        [cell createTextField];
        if (indexPath.row == 0) {
            UIPickerView *pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, VC_WIDTH, 200)];
            pickview.delegate = self;
            pickview.dataSource = self;
            cell.content.inputView = pickview;
            pickview.tag = tag;
            pickview.showsSelectionIndicator = YES;
        }
        else if (indexPath.row == 1){
            UIDatePicker *birthPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2+70, SCREEN_WIDTH, SCREEN_HEIGHT/2-70)];
            birthPicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [birthPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
            cell.content.inputView = birthPicker;
            //设置显示格式
            //默认根据手机本地设置显示为中文还是其他语言
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
            birthPicker.locale = locale;
            [birthPicker setDatePickerMode:UIDatePickerModeDate];
        }
        cell.content.delegate = self;
        cell.content.tag = tag;
        [cell loadModelWithTitle:titleList[1+indexPath.row] AndItem:modelList[indexPath.row+1]];
    }else {
        [cell loadModelWithTitle:titleList[5+indexPath.row] AndItem:nil];
    }
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //修改密码
        if (indexPath.row == 0) {
            modifyPasswordVC *modify = [[modifyPasswordVC alloc]init];
            [self.navigationController pushViewController:modify animated:YES];
        }
        //注销登录
        else{
            loginRegisterVC *loginvc = [[loginRegisterVC alloc]init];
            [self.navigationController pushViewController:loginvc animated:YES];
        }
    }
}
#pragma mark ----------datePicker
- (void)dateChanged:(UIDatePicker*)datepicker{
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [pickerFormatter stringFromDate:datepicker.date];
    _tempContent = dateString;
}

#pragma mark ----------textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag<=2) {
        if (textField.tag == 1){
            textField.text = _tempContent;
            _tempContent = [textField.text isEqualToString: @"男"]?@"0":@"1";
        }
        else if(textField.tag == 2){
            textField.text = _tempContent;
            _tempContent = [NSString ageFromDate:textField.text];
        }
        [modelList replaceObjectAtIndex:textField.tag withObject:_tempContent];
    }else{
        [modelList replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
}



- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark -------------------------------- VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
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
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

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

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        //        CGFloat w = 20.0f; CGFloat h = w;
        //        CGFloat x = (_portraitImageView.superview.frame.size.width - w) / 2;
        //        CGFloat y = (_portraitImageView.superview.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(115,NAV_HEIGHT+20,50,50)];
        
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        //_portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        //_portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

@end
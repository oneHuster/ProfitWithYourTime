//
//  ZYTmagnifyBrowser.m
//  weibo
//
//  Created by 邹应天 on 15/12/5.
//  Copyright © 2015年 邹应天. All rights reserved.
//

#import "ZYTmagnifyBrowser.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
static CGRect oldframe;
@class ZYTmagnifyBrowser;
@implementation ZYTmagnifyBrowser

//- (instancetype)initWithImage:(UIImageView *)image {
//    self = [super init];
//    if (self) {
//        [self showImage:image];
//    }
//    return self;
//}
-(void)showImage:(UIImageView *)imageView{
    UIImage *image=imageView.image;
    self.myImageView=imageView;
    //NSLog(@"image size is %@",NSStringFromCGSize(image.size));
    //UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    //UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_W, SCREEN_H)];
    //UIScrollView *imageScroller=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
   
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 100, 200, 200)];
//    label.backgroundColor=[UIColor greenColor];
//    [imageScroller addSubview:label];
    //oldframe=[imageView convertRect:imageView.bounds toView:backgroundView];
    //NSLog(@"imageView frame is %@",NSStringFromCGRect(oldframe));
        //backgroundView.backgroundColor=[UIColor blackColor];
        //backgroundView.alpha=0;
    UIImageView *newImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, (SCREEN_W/image.size.width)*image.size.height)];
    self.contentSize= CGSizeMake(SCREEN_W,newImageView.frame.size.height);
      newImageView.image=image;
        newImageView.tag=1;
//        [imageScroller addSubview:newImageView];
//        [backgroundView addSubview:imageScroller];
//    [window addSubview:backgroundView];
    [self addSubview:newImageView];
    //[window addSubview:self];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    [self addGestureRecognizer:longPress];
    [self addGestureRecognizer: tap];
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        //newImageView.frame=CGRectMake(0,(SCREEN_H-image.size.height*SCREEN_W/image.size.width)/2, SCREEN_W, image.size.height*SCREEN_W/image.size.width);
        self.alpha=1;
    } completion:^(BOOL finished) {
        
    }];

}
- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)saveImage:(UILongPressGestureRecognizer*)longPress{
    UIActionSheet *actSheet=[[UIActionSheet alloc]initWithTitle:@"你想干什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存至相册" otherButtonTitles:nil];
    //UIView *view=longPress.view;
    [actSheet showInView:self];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self saveImageToAlbum:self.myImageView.image];
    }
}
- (void)saveImageToAlbum:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.myImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}
@end

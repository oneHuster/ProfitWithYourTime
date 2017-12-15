//
//  AudioRecorder.h
//  闲么
//
//  Created by 邹应天 on 16/2/7.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^ZYTTextBlock) (NSString *myText);

//录音时的音量
typedef void (^ZYTAudioVolumeBlock) (CGFloat volume);

//录音存储地址
typedef void (^ZYTAudioURLBlock) (NSURL *audioURL);

//改变根据文字改变TextView的高度
typedef void (^ZYTContentSizeBlock)(CGSize contentSize);

//录音取消的回调
typedef void (^ZYTCancelRecordBlock)(int flag);





@interface ZYTAudioRecorder : NSObject<AVAudioRecorderDelegate>

@property AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) NSURL *audioPlayURL;
//contentsinz
@property (strong, nonatomic) ZYTContentSizeBlock sizeBlock;
//传输volome的block回调
@property (strong, nonatomic) ZYTAudioVolumeBlock volumeBlock;
//传输录音地址
@property (strong, nonatomic) ZYTAudioURLBlock urlBlock;
//录音取消
@property (strong, nonatomic) ZYTCancelRecordBlock cancelBlock;
@property NSTimer *timer;
//录音对象初始化
-(void)audioInit;
//开始录音
-(void)startAudioRecording;
//结束录音
-(void)stopAudioRecording;
-(CGFloat)getAudioRecordTime;
//录音声音大小
-(void)audioPowerChange;



//设置声音回调
-(void) setAudioVolumeBlock:(ZYTAudioVolumeBlock) block;

//设置录音地址回调
-(void) setAudioURLBlock:(ZYTAudioURLBlock) block;

-(void)setContentSizeBlock:(ZYTContentSizeBlock) block;

-(void)setCancelRecordBlock:(ZYTCancelRecordBlock)block;

-(void) changeFunctionHeight: (float) height;

@end

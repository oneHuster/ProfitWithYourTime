//
//  AudioRecorder.m
//  闲么
//
//  Created by 邹应天 on 16/2/7.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "ZYTAudioRecorder.h"

@implementation ZYTAudioRecorder


//录音部分初始化
-(void)audioInit
{
    NSError * err = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&err];
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    //通过可变字典进行配置项的加载
    NSMutableDictionary *setAudioDic = [[NSMutableDictionary alloc] init];
    
    //设置录音格式(aac格式)
    [setAudioDic setValue:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [setAudioDic setValue:@(44100) forKey:AVSampleRateKey];
    
    //设置录音通道数1 Or 2
    [setAudioDic setValue:@(1) forKey:AVNumberOfChannelsKey];
    
    //线性采样位数  8、16、24、32
    [setAudioDic setValue:@16 forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [setAudioDic setValue:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    //根据时间生成文件名
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.aac", strUrl, fileName]];
    _audioPlayURL = url;
    NSLog(@"%@",strUrl);
    NSError *error;
    //初始化
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setAudioDic error:&error];
    //开启音量检测
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    
}

-(void)startAudioRecording{
    //开始在录音
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
         //self.timer.fireDate=[NSDate distantPast];
    }
    
}
//结束录音
-(void)stopAudioRecording{
    [self.audioRecorder stop];
    
}
-(CGFloat)getAudioRecordTime{
    [_timer invalidate];
    return self.audioRecorder.currentTime;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
//    CGFloat progress=(1.0/160.0)*(power+160.0);
    //[self.audioPower setProgress:progress];
}

//录音的音量探测
- (void)detectionVoice
{
    [self.audioRecorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    CGFloat lowPassResults = pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:0]));
    
    //把声音的音量传给调用者
    self.volumeBlock(lowPassResults);
}

//设置音量
-(void)setAudioVolumeBlock:(ZYTAudioVolumeBlock)block
{
    self.volumeBlock = block;
}

-(void)setAudioURLBlock:(ZYTAudioURLBlock)block
{
    //self.urlBlock = block;
}

-(void)setContentSizeBlock:(ZYTContentSizeBlock)block
{
  //  self.sizeBlock = block;
}

-(void)setCancelRecordBlock:(ZYTCancelRecordBlock)block
{
    //self.cancelBlock = block;
}

@end

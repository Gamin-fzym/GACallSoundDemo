//
//  GAMsgBell.m
//  Midoutu
//
//  Created by apple on 2020/1/3.
//  Copyright © 2020 Alex. All rights reserved.
//

#import "GAMsgBell.h"

static GAMsgBell *sharedMsgBell = nil;

@implementation GAMsgBell

+ (id)sharedMsgBellMethod {
    @synchronized (self){
        if (!sharedMsgBell) {
            sharedMsgBell = [[GAMsgBell alloc] init];
        }
        return sharedMsgBell;
    }
    return sharedMsgBell;
}

- (void)setupSystemShake {
    [self stop];
    sound = kSystemSoundID_Vibrate; // 震动
}
 
- (void)setupSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType {
    [self stop];
    //NSString *path1 = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    //NSString *path2 = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ] pathForResource:soundName ofType:soundType];// 得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //[[NSBundle mainBundle] URLForResource:@"tap" withExtension: @"aif"]; //  获取自定义的声音
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:soundType];
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {
            // 获取的声音的时候，出现错误
            sound = nil;
        }
    }
}
 
- (void)setupCompletion:(AudioServicesSystemSoundCompletionProc)completeBlock {
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, completeBlock, NULL);
}

- (void)play {
    // 铃声静音仍然可播放声音
    // [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    AudioServicesPlaySystemSound(sound);
}

- (void)stop {
    [self stopCompletion];
    [self stopPlay];
}

- (void)stopCompletion {
    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
}

- (void)stopPlay {
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

@end

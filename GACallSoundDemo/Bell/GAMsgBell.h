//
//  GAMsgBell.h
//  Midoutu
//
//  Created by apple on 2020/1/3.
//  Copyright © 2020 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface GAMsgBell : NSObject {
    SystemSoundID sound; // 系统声音的id 取值范围为：1000-2000
}

+ (id)sharedMsgBellMethod;

// 系统 震动
- (void)setupSystemShake;

// 初始化系统声音、自定义声音
- (void)setupSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;

// 设置播放完成回调
- (void)setupCompletion:(AudioServicesSystemSoundCompletionProc)completeBlock;

// 停止回调、停止播放
- (void)stop;

// 播放
- (void)play;

@end

NS_ASSUME_NONNULL_END

//
//  ViewController.m
//  GACallSoundDemo
//
//  Created by apple on 2020/1/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ViewController.h"
#import "RBDMuteSwitch.h"
#import "GAMsgBell.h"

@interface ViewController () <RBDMuteSwitchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RBDMuteSwitch sharedInstance] setDelegate:self];
}

- (IBAction)callAction:(id)sender {
    // 检测”静音模式“是否开启
    [[RBDMuteSwitch sharedInstance] detectMuteSwitch];
}

- (IBAction)linkAction:(id)sender {
    GAMsgBell *bell = [GAMsgBell sharedMsgBellMethod];
    [bell stop];
}

#pragma mark - RBDMuteSwitchDelegate

- (void)isMuted:(BOOL)muted {
    if (muted) {
        // 当前是[静音模式]
        // 若在“设置-声音-开启了静音模式震动”手机才会震动，未开启静音模式震动时手机是静音的，这里就是设置了震动去播放仍然设备是静音的。
        NSLog(@"[静音模式]");
        GAMsgBell *bell = [GAMsgBell sharedMsgBellMethod];
        [bell setupSystemShake];
        [bell setupCompletion:soundCompleteCallback];
        [bell play];
    } else {
        // 当前是[响铃模式]
        NSLog(@"[响铃模式]");
        GAMsgBell *bell = [GAMsgBell sharedMsgBellMethod];
        [bell setupSystemSoundWithName:@"iphone6dx" SoundType:@"caf"];
        [bell setupCompletion:soundCompleteCallback];
        [bell play];
    }
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void * clientData) {
    NSLog(@"播放完成...");
    GAMsgBell *bell = [GAMsgBell sharedMsgBellMethod];
    [bell play];
}

@end

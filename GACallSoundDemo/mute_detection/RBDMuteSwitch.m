//
//  RBDMuteSwitch.m
//  RBDMuteSwitchExample
//
//  Created by Richard Hyland on 18/04/2012.
//  Copyright (c) 2012 RBDSolutions Limited. All rights reserved.
//

#import "RBDMuteSwitch.h"

static RBDMuteSwitch *_sharedInstance;

@implementation RBDMuteSwitch

@synthesize delegate;

+ (RBDMuteSwitch *)sharedInstance
{
	if (!_sharedInstance) {
        _sharedInstance = [[[self class] alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self) {
	}
	
	return self;
}

- (void)playbackComplete {
    if ([(id)self.delegate respondsToSelector:@selector(isMuted:)]) {
//        NSLog(@"playbackComplete >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\nsoundDuration    %f",soundDuration);
        // If playback is far less than 100ms then we know the device is muted
        if (soundDuration < 0.001) {
            [delegate isMuted:YES];
        }
        else {
             [delegate isMuted:NO];
        }
    }
    [playbackTimer invalidate];
    playbackTimer = nil;
    
    
}

static void soundCompletionCallback (SystemSoundID mySSID, void* myself) {
	AudioServicesRemoveSystemSoundCompletion (mySSID);
	[[RBDMuteSwitch sharedInstance] playbackComplete];
}

- (void)incrementTimer {
    soundDuration = soundDuration + 0.001;
//    NSLog(@"incrementTimer>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\nsoundDuration    %f",soundDuration);
}

- (void)detectMuteSwitch {
#if TARGET_IPHONE_SIMULATOR
	// The simulator doesn't support detection and can cause a crash so always return muted
    if ([(id)self.delegate respondsToSelector:@selector(isMuted:)]) {
        [self.delegate isMuted:YES];
    }
    return;
#endif
#if !TARGET_IPHONE_SIMULATOR 
    // iOS 5+ doesn't allow mute switch detection using state length detection
    // So we need to play a blank 100ms file and detect the playback length
    soundDuration = 0.0;
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    
    // Get the main bundle for the app
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle();
    
    // Get the URL to the sound file to play
    soundFileURLRef  =	CFBundleCopyResourceURL(
                                                mainBundle,
                                                CFSTR ("detection"),
                                                CFSTR ("aiff"),
                                                NULL
                                                );
    
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    
    AudioServicesAddSystemSoundCompletion (soundFileObject,NULL,NULL,
                                           soundCompletionCallback,
                                           (void*) CFBridgingRetain(self));
    
    // Start the playback timer
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.010 target:self selector:@selector(incrementTimer) userInfo:nil repeats:YES];
//    NSLog(@"playbackTimer>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\nsoundDuration    %f",soundDuration);
	// Play the sound
    AudioServicesPlaySystemSound(soundFileObject);
    return;
#endif
    
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
//    // This method doesn't work under iOS 5+
//    CFStringRef state;
//    UInt32 propertySize = sizeof(CFStringRef);
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
//    if(CFStringGetLength(state) > 0) {
//		if ([(id)self.delegate respondsToSelector:@selector(isMuted:)]) {
//            [self.delegate isMuted:NO];
//        }
//	}
//    if ([(id)self.delegate respondsToSelector:@selector(isMuted:)]) {
//        [self.delegate isMuted:YES];
//    }
//    return;
//#endif
}

@end

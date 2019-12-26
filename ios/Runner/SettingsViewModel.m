//
//  SettingsViewModel.m
//  SDKSampleApp
//
//  This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
//  This code is licensed pursuant to the BSD 3-Clause License.
//

#import "SettingsViewModel.h"

NSString * const BitmapOverlayKey = @"BitmapOverlayKey";
NSString * const BlackAndWhiteKey = @"BlackAndWhiteKey";
NSString * const RecordVideoLocallyKey = @"RecordVideoLocallyKey";
NSString * const PlaybackPrerollKey = @"PlaybackPrerollKey";
NSString * const AllowHLSKey = @"AllowHLSKey";
NSString * const HLSURLKey = @"HLSURLKey";
NSString * const ConnectionCodeKey = @"ConnectionCodeKey";

@interface SettingsViewModel ()


@end

@implementation SettingsViewModel

- (NSArray<NSString *>*) videoQualityDisplayNames {
    NSMutableArray<NSString*> *names = [NSMutableArray new];
    
    for (WowzaConfig *config in _supportedPresetConfigs)
        [names addObject:config.description];
    
    return names;
}

- (NSUInteger) selectedVideoQuality {
    NSUInteger selected = NSNotFound;
    
    NSInteger index = 0;
    for (WowzaConfig *config in _supportedPresetConfigs) {
        if (config.videoWidth == self.config.videoWidth &&
            config.videoHeight == self.config.videoHeight &&
            config.videoBitrate == self.config.videoBitrate &&
            config.videoFrameRate == self.config.videoFrameRate &&
            config.videoKeyFrameInterval == self.config.videoKeyFrameInterval) {
            selected = index;
            break;
        }
        index++;
    }
    
    return selected;
}

- (void) setSelectedVideoQuality:(NSUInteger)selectedVideoQuality {
    if (selectedVideoQuality < _supportedPresetConfigs.count) {
        WOWZMediaConfig *config = _supportedPresetConfigs[selectedVideoQuality];
        self.config.videoWidth = config.videoWidth;
        self.config.videoHeight = config.videoHeight;
        self.config.videoBitrate = config.videoBitrate;
        self.config.videoFrameRate = config.videoFrameRate;
        self.config.videoKeyFrameInterval = config.videoKeyFrameInterval;
    }
}

- (NSString *) videoConfigDescription {
    return self.config.description;
}

- (NSString *) hostAddress {
    return self.config.hostAddress;
}

- (void) setHostAddress:(NSString *)hostAddress {
    self.config.hostAddress = hostAddress;
}

- (NSString *) port {
    return [NSNumber numberWithInteger:self.config.portNumber].stringValue;
}

- (void) setPort:(NSString *)port {
    self.config.portNumber = port.integerValue;
}

- (NSString *) applicationName {
    return self.config.applicationName;
}

- (void) setApplicationName:(NSString *)applicationName {
    self.config.applicationName = applicationName;
}

- (NSString *) streamName {
    return self.config.streamName;
}

- (void) setStreamName:(NSString *)streamName {
    self.config.streamName = streamName;
}

- (NSString *) username {
    return self.config.username;
}

- (void) setUsername:(NSString *)username {
    self.config.username = username;
}

- (NSString *) password {
    return self.config.password;
}

- (void) setPassword:(NSString *)password {
    self.config.password = password;
}

- (BOOL) capturedVideoRotates {
    return self.config.capturedVideoRotates;
}

- (void) setCapturedVideoRotates:(BOOL)capturedVideoRotates {
    self.config.capturedVideoRotates = capturedVideoRotates;
}

- (BOOL) videoPreviewRotates {
    return self.config.videoPreviewRotates;
}

- (void) setVideoPreviewRotates:(BOOL)videoPreviewRotates {
    self.config.videoPreviewRotates = videoPreviewRotates;
}

- (WOWZBroadcastOrientation) broadcastVideoOrientation {
    return self.config.broadcastVideoOrientation;
}

- (void) setBroadcastVideoOrientation:(WOWZBroadcastOrientation)broadcastVideoOrientation {
    self.config.broadcastVideoOrientation = broadcastVideoOrientation;
}

- (WOWZBroadcastScaleMode) broadcastScaleMode {
    return self.config.broadcastScaleMode;
}

- (void) setBroadcastScaleMode:(WOWZBroadcastScaleMode)broadcastScaleMode {
    self.config.broadcastScaleMode = broadcastScaleMode;
}

- (BOOL) bitmapOverlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:BitmapOverlayKey];
}

- (void) setBitmapOverlay:(BOOL)bitmapOverlay {
    [[NSUserDefaults standardUserDefaults] setBool:bitmapOverlay forKey:BitmapOverlayKey];
}

- (BOOL) blackAndWhite {
    return [[NSUserDefaults standardUserDefaults] boolForKey:BlackAndWhiteKey];
}

- (void) setBlackAndWhite:(BOOL)blackAndWhite {
    [[NSUserDefaults standardUserDefaults] setBool:blackAndWhite forKey:BlackAndWhiteKey];
}

- (BOOL) recordVideoLocally {
    return [[NSUserDefaults standardUserDefaults] boolForKey:RecordVideoLocallyKey];
}

- (void) setRecordVideoLocally:(BOOL)recordVideoLocally {
    [[NSUserDefaults standardUserDefaults] setBool:recordVideoLocally forKey:RecordVideoLocallyKey];
}

- (NSString *) customFrameWidth {
    return [NSNumber numberWithInteger:self.config.videoWidth].stringValue;
}

- (void) setCustomFrameWidth:(NSString *)customFrameWidth {
    if (customFrameWidth.length) {
        self.config.videoWidth = customFrameWidth.integerValue;
    }
}

- (NSString *) customFrameHeight {
    return [NSNumber numberWithInteger:self.config.videoHeight].stringValue;
}

- (void) setCustomFrameHeight:(NSString *)customFrameHeight {
    if (customFrameHeight.length) {
        self.config.videoHeight = customFrameHeight.integerValue;
    }
}

- (NSString *) customVideoBitrate {
    return [NSNumber numberWithInteger:self.config.videoBitrate].stringValue;
}

- (void) setCustomVideoBitrate:(NSString *)customVideoBitrate {
    self.config.videoBitrate = customVideoBitrate.integerValue;
}

- (NSString *) customVideoFrameRate {
    return [NSNumber numberWithInteger:self.config.videoFrameRate].stringValue;
}

- (void) setCustomVideoFrameRate:(NSString *)customVideoFrameRate {
    self.config.videoFrameRate = customVideoFrameRate.integerValue;
}

- (NSString *) customVideoKeyFrameInterval {
    return [NSNumber numberWithInteger:self.config.videoKeyFrameInterval].stringValue;
}

- (void) setCustomVideoKeyFrameInterval:(NSString *)customVideoKeyFrameInterval {
    self.config.videoKeyFrameInterval = customVideoKeyFrameInterval.integerValue;
}

- (NSString *) audioBitrate {
    if (self.config.audioBitrate == 0) return nil;
    return [NSNumber numberWithInteger:self.config.audioBitrate].stringValue;
}

- (void) setAudioBitrate:(NSString *)audioBitrate {
    self.config.audioBitrate = (audioBitrate == nil ? 0 : audioBitrate.integerValue);
}

- (NSString *) audioSampleRate {
    if (self.config.audioSampleRate == 0) return nil;
    return [NSNumber numberWithInteger:self.config.audioSampleRate].stringValue;
}

- (void) setAudioSampleRate:(NSString *)audioSampleRate {
    self.config.audioSampleRate = (audioSampleRate == nil ? 0 : audioSampleRate.integerValue);
}

- (NSString *) audioChannels {
    return [NSNumber numberWithInteger:self.config.audioChannels].stringValue;
}

- (void) setAudioChannels:(NSString *)audioChannels {
    self.config.audioChannels = audioChannels.integerValue;
}

- (NSString *) videoBitrateScale {
    return [NSNumber numberWithFloat:self.config.videoBitrateLowBandwidthScalingFactor].stringValue;
}

- (void) setVideoBitrateScale:(NSString *)videoBitrateScale {
    self.config.videoBitrateLowBandwidthScalingFactor = videoBitrateScale.floatValue;
}

- (NSString *) videoFrameBufferMultiplier {
    return [NSNumber numberWithInteger:self.config.videoFrameBufferSizeMultiplier].stringValue;
}

- (void) setVideoFrameBufferMultiplier:(NSString *)videoFrameBufferMultiplier {
    self.config.videoFrameBufferSizeMultiplier = videoFrameBufferMultiplier.integerValue;
}

- (NSString *) videoFrameSkipCount {
    return [NSNumber numberWithInteger:self.config.videoFrameRateLowBandwidthSkipCount].stringValue;
}

- (void) videoFrameSkipCount:(NSString *)videoFrameSkipCount {
    self.config.videoFrameRateLowBandwidthSkipCount = videoFrameSkipCount.integerValue;
}

- (BOOL) backgroundBroadcastEnabled {
    return self.config.backgroundBroadcastEnabled;
}

- (void) setBackgroundBroadcastEnabled:(BOOL)backgroundBroadcastEnabled {
    self.config.backgroundBroadcastEnabled = backgroundBroadcastEnabled;
}

- (BOOL) mirrorFrontCamera {
    return self.config.mirrorFrontCamera;
}

- (void) setMirrorFrontCamera:(BOOL)mirrorFrontCamera {
    self.config.mirrorFrontCamera = mirrorFrontCamera;
}

- (BOOL) allowHLS {
	return [[NSUserDefaults standardUserDefaults] boolForKey:AllowHLSKey];
}

- (void) setAllowHLS:(BOOL)allowHLS {
	self.config.allowHLSPlayback = allowHLS;
	[[NSUserDefaults standardUserDefaults] setBool:allowHLS forKey:AllowHLSKey];
}

- (NSString *) hlsURL {
	NSString *hlsURL = [[NSUserDefaults standardUserDefaults] stringForKey:HLSURLKey];
	return hlsURL;
}

- (void) setHlsURL:(NSString *)hlsURL {
	self.config.hlsURL = hlsURL;
	[[NSUserDefaults standardUserDefaults] setObject:hlsURL forKey:HLSURLKey];
}


- (NSString *) playbackPrerollDuration {
    float duration =  [[NSUserDefaults standardUserDefaults] floatForKey:PlaybackPrerollKey];
    return [NSNumber numberWithFloat:duration].stringValue;
}

- (void) setPlaybackPrerollDuration:(NSString *)playbackPrerollDuration {
    float duration = playbackPrerollDuration.floatValue;
    [[NSUserDefaults standardUserDefaults] setFloat:duration forKey:PlaybackPrerollKey];
}

- (NSString *) connectionCode {
	NSString *connectionCode = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectionCodeKey];
	return connectionCode;
}

- (void) setConnectionCode:(NSString *)connectionCode {
	[[NSUserDefaults standardUserDefaults] setObject:connectionCode forKey:ConnectionCodeKey];
}
    
- (WOWZVideoRenderMethod) videoRenderingMethod {
    return self.config.videoRenderingMethod;
}
    
- (void) setVideoRenderingMethod:(WOWZVideoRenderMethod)videoRenderingMethod {
    self.config.videoRenderingMethod = videoRenderingMethod;
}
    

- (instancetype) initWithSessionConfig:(WowzaConfig *)config {
    if (self = [super init]) {
        _config = config;
    }
    
    return self;
}

@end
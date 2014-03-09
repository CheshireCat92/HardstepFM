//
//  ViewController.m
//  Hardstep radio
//
//  Created by Родштейн Алексей on 07.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize allowsAirPlay, nowPlaying, toolBar, playButton, pauseButton, movieDuration, volume;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *stringURL = @"http://89.221.207.241:8888/";
    NSURL *streamURL = [NSURL URLWithString:stringURL];
    
    asset = [AVURLAsset URLAssetWithURL:streamURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [playerItem addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([self isPlaying])
    {
        [self showPauseButton];
    }
    else
    {
        [self showPlayButton];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

static Float64 secondsWithCMTimeOrZeroIfInvalid(CMTime time)
{
    return CMTIME_IS_INVALID(time) ? 0.0f : CMTimeGetSeconds(time);
}

- (Float64)durationInSeconds
{
    return secondsWithCMTimeOrZeroIfInvalid(self.movieDuration);
}

- (void)handleDurationDidChange
{
    movieDuration = player.currentItem.duration;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItem *pItem = (AVPlayerItem *)object;
        if (pItem.status == AVPlayerItemStatusReadyToPlay)
        {
            [self playPause];
        }
    }
    if ([keyPath isEqualToString:@"timedMetadata"] && [self isPlaying])
    {
        for (AVAssetTrack *track in player.currentItem.tracks)
        {
            for (AVPlayerItemTrack *item in player.currentItem.tracks)
            {
                if ([item.assetTrack.mediaType isEqual:AVMediaTypeAudio])
                {
                    NSArray *meta = [playerItem timedMetadata];
                    for (AVMetadataItem *metaItem in meta)
                    {
                        if(nowPlaying.hidden == YES)
                        {
                            nowPlaying.hidden = NO;
                        }
                        NSString *source = metaItem.stringValue;
                        nowPlaying.text = [NSString stringWithFormat:@"%@",source];
                    }
                }
            }
        }
    }
}

- (BOOL)isPlaying
{
    return [player rate] != 0.f;
}

- (void)showPauseButton
{
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[toolBar items]];
    [toolbarItems replaceObjectAtIndex:0 withObject:pauseButton];
    [toolbarItems removeObject:playButton];
    toolBar.items = toolbarItems;
}

- (void)showPlayButton
{
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[toolBar items]];
    [toolbarItems replaceObjectAtIndex:0 withObject:playButton];
    [toolbarItems removeObject:pauseButton];
    toolBar.items = toolbarItems;
}

- (void)playPause
{
    if ([self isPlaying])
    {
        [self showPauseButton];
    }
    else
    {
        [self showPlayButton];
    }
}

- (void)togglePlayPause
{
    if ([self isPlaying])
    {
        [player pause];
        [self showPlayButton];
    }
    else
    {
        [player play];
        [self showPauseButton];
    }
}

- (void)enablePlayerButtons
{
    self.playButton.enabled = YES;
    self.pauseButton.enabled = YES;
}

- (void)disablePlayerButtons
{
    self.playButton.enabled = NO;
    self.pauseButton.enabled = NO;
}

- (IBAction)play:(id)sender
{
    [player play];
    [self showPauseButton];
}

- (IBAction)pause:(id)sender
{
    [player pause];
    [self showPlayButton];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"remoteControlReceivedWithEvent");
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self togglePlayPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    self.toolBar = nil;
    self.playButton = nil;
    self.pauseButton = nil;
    self.nowPlaying = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

//
//  MainViewController.m
//  Hardstep radio
//
//  Created by Родштейн Алексей on 14.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize infoButton, playButton, pauseButton, nowPlaying, slides;

#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Адрес потока
    NSString *stringURL = @"http://89.221.207.241:8888/";
    NSURL *streamURL = [NSURL URLWithString:stringURL];
    
    
    //Настройки класса плеера
    asset = [AVURLAsset URLAssetWithURL:streamURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [playerItem addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self playPause];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark Funktions

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
        for (AVPlayerItemTrack *item in player.currentItem.tracks)
        {
            if ([item.assetTrack.mediaType isEqual:AVMediaTypeAudio])
            {
                //Обработка мета данных
                NSArray *meta = [playerItem timedMetadata];
                for (AVMetadataItem *metaItem in meta)
                {
                    if(nowPlaying.hidden == YES)
                    {
                        nowPlaying.hidden = NO;
                    }
                    NSString *source = metaItem.stringValue;
                    nowPlaying.text = [NSString stringWithFormat:@"%@",source];
                    NSLog(@"%@",source);
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
}

- (void)showPlayButton
{
}

- (void)playPause
{
    
}

- (void)enablePlayerButtons
{
    
}

- (void)disablePlayerButtons
{
    
}

#pragma mark Actions

- (IBAction)changeVolume:(id)sender
{
    //Action для регулятора громкости, необходимо синхронизировать вместе с системным
    [player setVolume:[slides value]];
}

- (IBAction)infoButtonPress:(id)sender
{
    
}

- (IBAction)play:(id)sender
{
    [player play];
    //[self showPauseButton];
}

- (IBAction)pause:(id)sender
{
    [player pause];
    //[self showPlayButton];
}

@end

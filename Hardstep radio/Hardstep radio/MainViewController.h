//
//  MainViewController.h
//  Hardstep radio
//
//  Created by Родштейн Алексей on 14.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Notification.h"

@class AVPlayer;
@class AVPlayerItem;

@interface MainViewController : UIViewController
{
    AVAsset *asset;
    AVPlayerItem *playerItem;
    AVPlayer *player;
}
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *nowPlaying;
@property (strong, nonatomic) IBOutlet UISlider *slides;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context;
- (BOOL)isPlaying;
- (void)showPauseButton;
- (void)showPlayButton;
- (void)playPause;
- (void)enablePlayerButtons;
- (void)disablePlayerButtons;

- (IBAction)changeVolume:(id)sender;
- (IBAction)infoButtonPress:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end

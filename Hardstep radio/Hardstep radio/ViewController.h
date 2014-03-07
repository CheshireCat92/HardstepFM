//
//  ViewController.h
//  Hardstep radio
//
//  Created by Родштейн Алексей on 07.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class AVPlayer;
@class AVPlayerItem;

@interface ViewController : UIViewController
{
    AVAsset *asset;
    AVPlayerItem *playerItem;
    AVPlayer *player;
    NSURL *mURL;
    
    IBOutlet UIImageView *logo;
    IBOutlet UILabel *nowPlaying;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIBarButtonItem *playButton;
    IBOutlet UIBarButtonItem *pauseButton;
    IBOutlet UILabel *memoryLoad;
    IBOutlet UILabel *timePlaying;
    IBOutlet UILabel *bpmInfo;
}

@property (strong, nonatomic) IBOutlet UIToolbar *volume;
@property (nonatomic) BOOL *allowsAirPlay;
@property (nonatomic, retain) IBOutlet UILabel *nowPlaying;
@property (retain) IBOutlet UIToolbar *toolBar;
@property (retain) IBOutlet UIBarButtonItem *playButton;
@property (retain) IBOutlet UIBarButtonItem *pauseButton;
@property (nonatomic, assign) CMTime movieDuration;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context;
- (BOOL)isPlaying;
- (void)showPauseButton;
- (void)showPlayButton;
- (void)playPause;
- (void)enablePlayerButtons;
- (void)disablePlayerButtons;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end

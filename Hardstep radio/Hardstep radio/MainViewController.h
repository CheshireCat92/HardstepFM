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
#import <Accelerate/Accelerate.h>

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AVAsset *asset;
    AVPlayerItem *playerItem;
    AVPlayer *player;
    
    //мета данные
    NSString *source;
    
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *pauseButton;
}

@property (strong, nonatomic) IBOutlet UIImageView *backLogo;
@property (strong, nonatomic) IBOutlet UIImageView *fontLogo;
@property (strong, nonatomic) IBOutlet UIImageView *mainLogo;
@property (strong, nonatomic) IBOutlet UIView *rootVIew;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

//модальник с табличкой
@property (strong, nonatomic)UITableView *trackTableView;
@property (strong, nonatomic)UIButton *openCloseModalTableView;
@property (strong, nonatomic)UIView *containerView;
@property (strong, nonatomic)UILabel *nowPlayingLabel1;
@property (strong, nonatomic)UILabel *nowPlayingLabel2;
@property bool showBoolVar;

@property NSString *source;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (BOOL)isPlaying;
- (void)playPause;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end

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
#import "CJSONDeserializer.h"
#import "FSAudioController.h"
#import "FSAudioStream.h"



@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    FSAudioController *audioController;
    FSAudioStream *audioStream;

    //мета данные
    NSMutableString *source;
    
    
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
//таблица
@property (strong, nonatomic)UITableView *trackTableView;
@property (strong, nonatomic)UIButton *openCloseModalTableView;
@property (strong, nonatomic)UIView *containerView;
@property (strong, nonatomic)UILabel *nowPlayingLabel1;
@property (strong, nonatomic)UILabel *nowPlayingLabel2;
@property (strong, nonatomic)NSMutableArray *songsDidPlayedMutableArray;
@property bool modalViewIsShow;
@property (strong, nonatomic) IBOutlet UIButton *addSameDataTestButton;
- (IBAction)addSameDataEvent:(id)sender;

//дескрипшн
@property (strong, nonatomic)UIView *descriptionContainerView;
@property (strong, nonatomic)UIButton *backToTableViewButton;
@property (strong, nonatomic)UIButton *soundcloudDownloadTrackButton;
@property (strong, nonatomic)UIButton *itunesBuyTrackButton;
@property (strong, nonatomic)UIImageView *songCoverImageView;
@property (strong, nonatomic)UILabel *songArtistLabel;
@property (strong, nonatomic)UILabel *songNameLabel;
@property (strong, nonatomic)UILabel *songAlbumNameLabel;
@property (strong, nonatomic)NSURL *ituneBuyLink;
@property (strong, nonatomic)UIImageView *activitiViewSaw;
@property (strong, nonatomic)NSString *tempSource; //необходимо для корректной работы таблицы (отсутствие повторений одного и того же трека)

//artistInfo
@property (strong, nonatomic) NSMutableArray* fullArtistInfo;
@property (strong, nonatomic) NSString* artworkUrl100;
@property (strong, nonatomic) NSString* artistId;
@property (strong, nonatomic) NSString* artistName;
@property (strong, nonatomic) NSString* collectionId;
@property (strong, nonatomic) NSString* collectionName;
@property (strong, nonatomic) NSString* trackId;
@property (strong, nonatomic) NSString* trackName;
@property (strong, nonatomic) NSMutableString* trackNameSingleValue;
@property NSString *source;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end

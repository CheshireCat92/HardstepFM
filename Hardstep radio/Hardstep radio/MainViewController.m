//
//  MainViewController.m
//  Hardstep radio
//
//  Created by Родштейн Алексей on 14.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    
}

@property int iterator;//временная хреновина

@end

@implementation MainViewController
@synthesize playButton, pauseButton, source;
@synthesize containerView,rootVIew,descriptionContainerView;//вьюха - контейнер, рут вью
@synthesize openCloseModalTableView,addSameDataTestButton,backToTableViewButton,soundcloudDownloadTrackButton,itunesBuyTrackButton;//кнопка
@synthesize trackTableView;//табличка
@synthesize modalViewIsShow;//булеановские переменные
@synthesize nowPlayingLabel1,nowPlayingLabel2,songAlbumNameLabel,songArtistLabel,songNameLabel;//лейблы
@synthesize mainLogo, fontLogo, backLogo,songCoverImageView;//логотипы
@synthesize songsDidPlayedMutableArray;//массивы
@synthesize iterator;//временная хреновина
@synthesize ituneBuyLink;//url
@synthesize artistId,artistName,artworkUrl100,trackId,trackName,collectionId,collectionName,fullArtistInfo;//инфа об артисте

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    songsDidPlayedMutableArray = [NSMutableArray new];
    iterator+=1;
    
    pauseButton.hidden = YES;
    
    //Адрес потока
    NSString *stringURL = @"http://89.221.207.241:8888/";
    NSURL *streamURL = [NSURL URLWithString:stringURL];
    
    
    audioStream = [[FSAudioStream alloc]init];
    audioController = [[FSAudioController alloc] initWithUrl:streamURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamStateDidChange:)
                                                 name:FSAudioStreamStateChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamMetaDataAvailable:)
                                                 name:FSAudioStreamMetaDataNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamErrorOccurred:)
                                                 name:FSAudioStreamErrorNotification
                                               object:nil];
   
    //Настройки класса плеера
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //настройка play/pause, логотипа и главного фона
    UIImage *backgroung = [UIImage imageNamed:@"Background.png"];
    rootVIew.backgroundColor = [UIColor colorWithPatternImage: backgroung];
    rootVIew.contentMode = UIViewContentModeScaleAspectFit;
    
    [mainLogo setImage:[UIImage imageNamed:@"logo.png"]];
    [fontLogo setImage:[UIImage imageNamed:@"logo_font.png"]];
    [backLogo setImage:[UIImage imageNamed:@"logo_back.png"]];

    [playButton setTitle:@"" forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [pauseButton setTitle:@"" forState:UIControlStateNormal];
    [pauseButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    
#pragma mark - ModalView Settings
    //настройка контейнера для тейбл-вьюхи
    containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-70,320,389)];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"tableViewBackground.png"]];
    [self.view addSubview:containerView];
    [self.view bringSubviewToFront:containerView];
    
    openCloseModalTableView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, 70)];
    [openCloseModalTableView setImage:[UIImage imageNamed:@"trackDisplayVar2.png"] forState:UIControlStateNormal];
    openCloseModalTableView.backgroundColor = [UIColor clearColor];
    openCloseModalTableView.hidden = NO;
    [openCloseModalTableView addTarget:self action:@selector(hideShowModalView) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:openCloseModalTableView];
    [containerView bringSubviewToFront:openCloseModalTableView];
    
    
    nowPlayingLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, openCloseModalTableView.bounds.size.width+10, openCloseModalTableView.bounds.size.height)];
    nowPlayingLabel1.text = @"";
    nowPlayingLabel1.textColor = [UIColor orangeColor];
    nowPlayingLabel1.backgroundColor = [UIColor clearColor];
    [nowPlayingLabel1 setFont:[UIFont fontWithName:@"Danger" size:25.0f]];
    nowPlayingLabel1.textAlignment = NSTextAlignmentCenter;
    [openCloseModalTableView addSubview:nowPlayingLabel1];
    [openCloseModalTableView bringSubviewToFront:nowPlayingLabel1];
    
    nowPlayingLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(openCloseModalTableView.bounds.size.width+1, 0, openCloseModalTableView.bounds.size.width+10, openCloseModalTableView.bounds.size.height)];
    nowPlayingLabel2.text = @"";
    nowPlayingLabel2.textColor = [UIColor orangeColor];
    nowPlayingLabel2.backgroundColor = [UIColor clearColor];
    [nowPlayingLabel2 setFont:[UIFont fontWithName:@"Danger" size:25.0f]];
    nowPlayingLabel2.textAlignment = NSTextAlignmentCenter;
    [openCloseModalTableView addSubview:nowPlayingLabel2];
    [openCloseModalTableView bringSubviewToFront:nowPlayingLabel2];
    
        UIImageView *bottomBoarderTrackDisplay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trackBottomBoarder"]];
    [bottomBoarderTrackDisplay setFrame:CGRectMake(-10, 10, openCloseModalTableView.bounds.size.width, openCloseModalTableView.bounds.size.height)];
    [openCloseModalTableView addSubview: bottomBoarderTrackDisplay];
    [openCloseModalTableView bringSubviewToFront:bottomBoarderTrackDisplay];
    
    UIImageView *leftBoarderTrackDisplay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SawBoarder"]];
    [leftBoarderTrackDisplay setFrame:CGRectMake(-20, -16, 90, 90)];
    [openCloseModalTableView addSubview: leftBoarderTrackDisplay];
    [openCloseModalTableView bringSubviewToFront:leftBoarderTrackDisplay];
    
    UIImageView *rightBoarderTrackDisplay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SawBoarder"]];
    [rightBoarderTrackDisplay setFrame:CGRectMake(250,-16, 90, 90)];
    [openCloseModalTableView addSubview: rightBoarderTrackDisplay];
    [openCloseModalTableView bringSubviewToFront:rightBoarderTrackDisplay];
    
    trackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, containerView.bounds.size.width, containerView.bounds.size.height) style:UITableViewStylePlain];
    trackTableView.delegate = self;
    trackTableView.dataSource = self;
    [trackTableView setBackgroundColor:[UIColor clearColor]];
    [trackTableView setScrollEnabled:YES];
    [trackTableView setContentSize:CGSizeMake(320, 409)];
    [containerView addSubview:trackTableView];
    [containerView bringSubviewToFront:trackTableView];
    
    UIImageView *leftBoarderTableView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftTableViewBoarders"]];
    [leftBoarderTableView setFrame:CGRectMake(-20, 0, 90, trackTableView.bounds.size.height)];
    [trackTableView addSubview: leftBoarderTableView];
    [trackTableView sendSubviewToBack:leftBoarderTableView];
    
    UIImageView *rightBoarderTableView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightTableViewBoarders"]];
    [rightBoarderTableView setFrame:CGRectMake(250,0, 90, trackTableView.bounds.size.height)];
    [trackTableView addSubview: rightBoarderTableView];
    [trackTableView sendSubviewToBack:rightBoarderTableView];
    
    modalViewIsShow = NO;

#pragma mark - ModalView Description Settings
    descriptionContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 70,320,389)];
    descriptionContainerView.hidden = NO;
    descriptionContainerView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:descriptionContainerView];
    [self.containerView bringSubviewToFront:descriptionContainerView];
    
    backToTableViewButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 270, 200, 50)];
    backToTableViewButton.backgroundColor = [UIColor clearColor];
    [backToTableViewButton setBackgroundImage:[UIImage imageNamed:@"tableViewCellPressed.png"] forState:UIControlStateNormal];
    [backToTableViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backToTableViewButton setTitle:@"Back" forState:UIControlStateNormal];
    backToTableViewButton.titleLabel.font = [UIFont fontWithName:@"Danger" size:14];
    [backToTableViewButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backToTableViewButton addTarget:self action:@selector(closeDescriptionView) forControlEvents:UIControlEventTouchUpInside];
    [descriptionContainerView addSubview:backToTableViewButton];
    [descriptionContainerView bringSubviewToFront:backToTableViewButton];
    
    UIImageView *cablePackRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightTableViewBoarders"]];
    cablePackRight.frame = CGRectMake(220, 40, 50, 170);
    [descriptionContainerView addSubview:cablePackRight];
    
    UIImageView *cabelPackCornerRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightTableViewCellBoarder"]];
    cabelPackCornerRight.frame = CGRectMake(150, 40, 100, 100);
    [descriptionContainerView addSubview:cabelPackCornerRight];
    
    itunesBuyTrackButton = [[UIButton alloc]initWithFrame:CGRectMake(190, 10, 130, 50)];
    itunesBuyTrackButton.backgroundColor = [UIColor clearColor];
    [itunesBuyTrackButton setBackgroundImage:[UIImage imageNamed:@"tableViewCell.png"] forState:UIControlStateNormal];
    [itunesBuyTrackButton setBackgroundImage:[UIImage imageNamed:@"tableViewCellPressed.png"] forState:UIControlStateSelected];
    [itunesBuyTrackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itunesBuyTrackButton setTitle:@"iTunes" forState:UIControlStateNormal];
    itunesBuyTrackButton.titleLabel.font = [UIFont fontWithName:@"Danger" size:12];
    [itunesBuyTrackButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [itunesBuyTrackButton addTarget:self action:@selector(buyIniTunes) forControlEvents:UIControlEventTouchUpInside];
    [descriptionContainerView addSubview:itunesBuyTrackButton];
    [descriptionContainerView bringSubviewToFront:itunesBuyTrackButton];
    
    UIImageView *songLabelImage = [UIImageView new];
    songLabelImage.backgroundColor = [UIColor clearColor];
    songLabelImage.image = [UIImage imageNamed:@"trackDisplayVar2"];
    songLabelImage.frame = CGRectMake(20, 176, 290, 40);
    [descriptionContainerView addSubview:songLabelImage];
    [descriptionContainerView bringSubviewToFront:songLabelImage];
    
    UIImageView *songAlbumImage = [UIImageView new]; //нижний текст
    songAlbumImage.backgroundColor = [UIColor clearColor];
    songAlbumImage.image = [UIImage imageNamed:@"trackDisplayVar2"];
    songAlbumImage.frame = CGRectMake(20, 220, 290, 40);
    [descriptionContainerView addSubview:songAlbumImage];
    [descriptionContainerView bringSubviewToFront:songAlbumImage];
    
    
    songAlbumNameLabel = [[UILabel alloc]init];
    songAlbumNameLabel.backgroundColor = [UIColor clearColor];
    songAlbumNameLabel.font = [UIFont fontWithName:@"Danger" size:25];
    songAlbumNameLabel.frame = CGRectMake(20, 174, 290, 40);
    songAlbumNameLabel.textColor = [UIColor orangeColor];
    songAlbumNameLabel.textAlignment = NSTextAlignmentCenter;
    [descriptionContainerView addSubview:songAlbumNameLabel];
    [descriptionContainerView bringSubviewToFront:songAlbumNameLabel];
    
    songArtistLabel = [[UILabel alloc]init];
    songArtistLabel.backgroundColor =[UIColor clearColor];
    songArtistLabel.font = [UIFont fontWithName:@"Danger" size:25];
    songArtistLabel.frame = CGRectMake(20, 218, 150, 40);
    songArtistLabel.textColor = [UIColor orangeColor];
    songArtistLabel.textAlignment = NSTextAlignmentCenter;
    [descriptionContainerView addSubview:songArtistLabel];
    [descriptionContainerView bringSubviewToFront:songArtistLabel];
    
    
    songNameLabel = [[UILabel alloc]init];
    songNameLabel.backgroundColor = [UIColor clearColor];
    songNameLabel.font = [UIFont fontWithName:@"Danger" size:25];
    songNameLabel.frame = CGRectMake(160, 218, 150, 40);
    songNameLabel.textColor = [UIColor orangeColor];
    songNameLabel.textAlignment = NSTextAlignmentCenter;
    [descriptionContainerView addSubview:songNameLabel];
    [descriptionContainerView bringSubviewToFront:songNameLabel];
    
    UIImageView *albumeNameBoarder = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trackBottomBoarder"]];
    albumeNameBoarder.frame = CGRectMake(0, 182, 320, 40);
    [descriptionContainerView addSubview:albumeNameBoarder];
    [descriptionContainerView bringSubviewToFront:albumeNameBoarder];
    
    UIImageView *artistNameBoarder = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trackBottomBoarder"]];
    artistNameBoarder.frame = CGRectMake(0, 227, 320, 40);
    [descriptionContainerView addSubview:artistNameBoarder];
    [descriptionContainerView bringSubviewToFront:artistNameBoarder];
    
    UIImageView *albumeCoverBoarderRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trackBottomBoarder"]];
    albumeCoverBoarderRight.frame = CGRectMake(75, 68, 180, 40);
    albumeCoverBoarderRight.transform = CGAffineTransformMakeRotation(4.7124);
    [descriptionContainerView addSubview:albumeCoverBoarderRight];
    [descriptionContainerView bringSubviewToFront:albumeCoverBoarderRight];
    
    UIImageView *albumeCoverBoarderLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trackBottomBoarder"]];
    albumeCoverBoarderLeft.frame = CGRectMake(-65, 62, 180, 40);
    albumeCoverBoarderLeft.transform = CGAffineTransformMakeRotation(1.5708);
    [descriptionContainerView addSubview:albumeCoverBoarderLeft];
    [descriptionContainerView bringSubviewToFront:albumeCoverBoarderLeft];
    
    UIImageView *chainRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GridDetailView" ]];
    chainRight.frame = CGRectMake(302, 50, 10, 143);
    [descriptionContainerView addSubview:chainRight];
    
    UIImageView *chainRightLow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CabelDescriptionView" ]];
    chainRightLow.frame = CGRectMake(280, 213, 50, 10);
    chainRightLow.transform = CGAffineTransformMakeRotation(1.5708);
    [descriptionContainerView addSubview:chainRightLow];
    
    UIImageView *chainLeftLow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CabelDescriptionView" ]];
    chainLeftLow.frame = CGRectMake(0, 213, 43, 10);
    chainLeftLow.transform = CGAffineTransformMakeRotation(1.5708);
    [descriptionContainerView addSubview:chainLeftLow];
    
    UIImageView *cabelCoverHi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CabelDescriptionView"]];
    cabelCoverHi.frame = CGRectMake(33, 3, 129, 15);
    [descriptionContainerView addSubview:cabelCoverHi];

    UIImageView *cabelCoverLow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CabelDescriptionView"]];
    cabelCoverLow.frame = CGRectMake(34, 161, 129, 15);
    [descriptionContainerView addSubview:cabelCoverLow];
    
    UIImageView *chainLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GridDetailView" ]];
    chainLeft.frame = CGRectMake(20, 50, 10, 143);
    [descriptionContainerView addSubview:chainLeft];
    
    
    songCoverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 150, 150)];
    songCoverImageView.backgroundColor = [UIColor blackColor];
    [descriptionContainerView addSubview:songCoverImageView];
    [descriptionContainerView bringSubviewToFront:songCoverImageView];
    
    
}

#pragma mark - Stream Functions

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    
    NSMutableString *streamInfo = [[NSMutableString alloc] init];
    
    if (metaData[@"StreamTitle"])
    {
        [streamInfo appendString:metaData[@"StreamTitle"]];
    }
    
    source = streamInfo;
    nowPlayingLabel1.text = [NSString stringWithFormat:@"%@",source];
    nowPlayingLabel2.text = [NSString stringWithFormat:@"%@",source];

    NSLog(@"source is - %@",source);
    if (source.length >= 25)//числа будут примерно в диапазоне 15-20
    {
        NSLog(@"Анимация");
        [self textAnimationInLabel];
    }
    else
    {
        //[self textAnimationInLabel];
    }
    NSLog(@"Song played - %@",streamInfo);
    
}

- (void)audioStreamStateDidChange:(NSNotification *)notification
{
    NSString *statusRetrievingURL = @"Retrieving stream URL";
    NSString *statusBuffering = @"Buffering...";
    NSString *statusSeeking = @"Seeking...";
    NSString *statusEmpty = @"";
    
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    
    switch (state)
    {
        case kFsAudioStreamRetrievingURL:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            nowPlayingLabel1.text = statusRetrievingURL;
            break;
            
        case kFsAudioStreamStopped:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            nowPlayingLabel1.text = statusEmpty;
            break;
            
        case kFsAudioStreamBuffering:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            nowPlayingLabel1.text = statusBuffering;
            break;
            
        case kFsAudioStreamSeeking:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            nowPlayingLabel1.text = statusSeeking;
            break;
            
        case kFsAudioStreamPlaying:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([nowPlayingLabel1.text isEqualToString:statusBuffering] ||
                [nowPlayingLabel1.text isEqualToString:statusRetrievingURL] ||
                [nowPlayingLabel1.text isEqualToString:statusSeeking])
            {
                nowPlayingLabel1.text = statusEmpty;
            }
            break;
            
        case kFsAudioStreamFailed:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            break;
    }
}

- (void)audioStreamErrorOccurred:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
            nowPlayingLabel1.text = @"Cannot open the audio stream";
            break;
        case kFsAudioStreamErrorStreamParse:
            nowPlayingLabel1.text = @"Cannot read the audio stream";
            break;
        case kFsAudioStreamErrorNetwork:
            nowPlayingLabel1.text = @"Network failed: cannot play the audio stream";
            break;
        case kFsAudioStreamErrorUnsupportedFormat:
            nowPlayingLabel1.text = @"Unsupported format";
            break;
        default:
            nowPlayingLabel1.text = @"Unknown error occurred";
            break;
    }
}

#pragma mark Actions

- (IBAction)play:(id)sender
{
    [audioController play];
    playButton.hidden = YES;
    pauseButton.hidden = NO;
}

- (IBAction)pause:(id)sender
{
    [audioController stop];
    playButton.hidden = NO;
    pauseButton.hidden = YES;
}



#pragma mark - TableView functions and Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songsDidPlayedMutableArray.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 40;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newCell"];
    newCell.backgroundColor = [UIColor clearColor];
    newCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableViewCell" ]];
    newCell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableViewCellPressed" ]];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -2, newCell.bounds.size.width-50 , newCell.bounds.size.height)];
    cellLabel.text = [NSString stringWithFormat:@"%@",[songsDidPlayedMutableArray objectAtIndex:indexPath.row]];
    cellLabel.font = [UIFont fontWithName:@"Danger" size:15.0f];
    cellLabel.textAlignment = NSTextAlignmentCenter;
    cellLabel.textColor = [UIColor blackColor];
    [newCell addSubview:cellLabel];
    [newCell bringSubviewToFront:cellLabel];
    
    UIImageView *leftBoarderTableViewCell = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftTableViewCellBoarder"]];
    [leftBoarderTableViewCell setFrame:CGRectMake(-50, -2, 90, newCell.bounds.size.height)];
    [newCell addSubview: leftBoarderTableViewCell];
    [newCell bringSubviewToFront:leftBoarderTableViewCell];
    
    UIImageView *rightBoarderTableViewCell = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightTableViewCellBoarder"]];
    [rightBoarderTableViewCell setFrame:CGRectMake(280,-2, 90, newCell.bounds.size.height)];
    [newCell addSubview: rightBoarderTableViewCell];
    [newCell bringSubviewToFront:rightBoarderTableViewCell];

    
    return newCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewOutAnimation];
    //NSString *newPath = [[NSString alloc]initWithString:[self createSearchITunesURLfromMetadataString:source]];
    [self parseJSONandCreateITunesBuyLinkWithSource:source];
    [self addDataToDescriptionView];
    

}


#pragma mark custom Functions

-(void)textAnimationInLabel
{
        [UILabel animateWithDuration:15.5f
                           delay:0.5f
                         options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse
                      animations:^
            {
                [nowPlayingLabel1 setFrame:CGRectMake(0-nowPlayingLabel1.bounds.size.width+10, 0, openCloseModalTableView.bounds.size.width+10, openCloseModalTableView.bounds.size.height)];
                [nowPlayingLabel2 setFrame:CGRectMake(0, 0, openCloseModalTableView.bounds.size.width+10, openCloseModalTableView.bounds.size.height)];
            
            }
    completion:^(BOOL finished)
    {
    }];

}

-(void)tableViewOutAnimation
{
    [UITableView animateWithDuration:2.0f
                               delay:0.1f
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                              [trackTableView setFrame:CGRectMake(-containerView.bounds.size.width, 70, containerView.bounds.size.width, containerView.bounds.size.height)];
                              [descriptionContainerView setFrame:CGRectMake(0, 70, 320, 389)];
                          }
                          completion:^(BOOL finished)
    {
                    
    }];
}

-(void)tableViewInAnimation
{
    [UITableView animateWithDuration:2.0f
                               delay:0.1f
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                              [trackTableView setFrame:CGRectMake(0, 70, containerView.bounds.size.width, containerView.bounds.size.height)];
                              
                              [descriptionContainerView setFrame:CGRectMake(320, 70,320,389)];
                          }
                          completion:^(BOOL finished)
     {
         
     }];

}

-(void)hideShowModalView //выползающий с низу модальник
{
    if (modalViewIsShow == YES)
    {
        [UIView animateWithDuration:0.5f animations:^
         {
             self.containerView.frame = CGRectMake(0, self.view.frame.size.height-70,320, 389);
             NSLog(@"закрыли");
             //[self tableViewInAnimation];
         }
         ];
        modalViewIsShow = NO;
        
    }
    else
    {
        
        [UIView animateWithDuration:0.5f animations:^
         {
             
             self.containerView.frame = CGRectMake(0,self.view.frame.size.height-390,320, 389);
             NSLog(@"открыли");
             
         }
         ];
        modalViewIsShow = YES;
        
        
        
    }
}

- (IBAction)addSameDataEvent:(id)sender
{
    NSNumber *newData = [[NSNumber alloc]initWithInt:iterator];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [songsDidPlayedMutableArray insertObject:newData atIndex:0];
    [trackTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [trackTableView reloadData];
    iterator++;
}

-(void)buyIniTunes
{
    NSURL *itunesURL = [NSURL new];
    [[UIApplication sharedApplication] openURL:itunesURL];
}

-(void)closeDescriptionView
{
    [self tableViewInAnimation];
}



-(NSString*)createSearchITunesURLfromMetadataString:(NSString*)string
{
    NSLog(@"createSearchITunesURLWithString");
    NSMutableString *songNameString = [[NSMutableString alloc]initWithString:string];
    NSLog(@"now played - %@",songNameString);
    NSLog(@"length - %lu",(unsigned long)songNameString.length);
    NSMutableString *artistNameString = [[NSMutableString alloc]initWithString:songNameString];
    NSMutableString *titleNameString = [[NSMutableString alloc]initWithString:songNameString];
    NSLog(@"length - %lu",(unsigned long)artistNameString.length);
    for (int i = 0; i<songNameString.length; i++)
    {
        NSLog(@" %i - %i",i,[songNameString characterAtIndex:i]);
        if ([songNameString characterAtIndex:i]==45)
        {
            if ([songNameString characterAtIndex:i-1]==32)
            {
                [artistNameString deleteCharactersInRange:NSMakeRange(i-1, artistNameString.length-i+1)];
            }
            [titleNameString deleteCharactersInRange:NSMakeRange(0, i+2)];
            NSLog(@"1Artist name is %@",artistNameString);
            NSLog(@"2Song title is %@",titleNameString);
            break;
        }
    }
    
    
    for (int i = 0;i<titleNameString.length; i++)
    {
        if ([titleNameString characterAtIndex:i]==32)
        {
            
            [titleNameString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"-"];
        }
    }
    for (int i = 0;i<titleNameString.length; i++)
    {
    if ([titleNameString characterAtIndex:i]==40)
        {
            [titleNameString deleteCharactersInRange:NSMakeRange(i, titleNameString.length-i)];
        }
    }
    for (int i = 0;i<artistNameString.length; i++)
    {
        if ([artistNameString characterAtIndex:i]==32)
        {
            [artistNameString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"+"];
        }
        if ([artistNameString characterAtIndex:i]==45)
        {
            [artistNameString deleteCharactersInRange:NSMakeRange(i,1)];
        }
        if (i == artistNameString.length)
        {
            [artistNameString deleteCharactersInRange:NSMakeRange(artistNameString.length, 1)];
        }
    }
    
    NSMutableString *newSearchPath = [NSMutableString new];
    [newSearchPath setString:@"https://itunes.apple.com/search?term="];
    NSString *tmpString = @"&limit=1&entity=musicTrack&term=";
    [newSearchPath appendString:artistNameString ];
    [newSearchPath appendString:tmpString];
    [newSearchPath appendString:titleNameString];
    NSLog(@"%@",newSearchPath);
    return newSearchPath;
}


-(void)parseJSONandCreateITunesBuyLinkWithSource:(NSString*)string
{
    
    NSString *stringUrl = [NSString new];
    stringUrl = [self createSearchITunesURLfromMetadataString:string]; //генерим поисковый запрос
    //занимаемся получением JSON файла через get-запрос
    [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc]initWithString:stringUrl];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resultString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    //распарсиваем JSON-файл в словарь
    CJSONDeserializer *JsonDeserializer = [CJSONDeserializer deserializer];
    NSMutableDictionary *resultJsonDict = [JsonDeserializer deserializeAsDictionary:jsonData  error:&error];
    NSLog(@"result Json dict is - %@",resultJsonDict);
    //сливаем всю ифну об артисте в новый словарик
    NSDictionary *artistInfo = [resultJsonDict objectForKey:@"results"];
    NSLog(@"artist info is - %@",artistInfo);
    NSLog(@"artist id is - %@",[artistInfo valueForKey:@"artistId"]);
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    //каждое значение - блядский словарь
    [tmpArray insertObject:[artistInfo valueForKey:@"artistId"] atIndex:0];
    artistId = [tmpArray objectAtIndex:0];
    [tmpArray insertObject:[artistInfo valueForKey:@"artistName"] atIndex:1];
    artistName = [tmpArray objectAtIndex:1];
    [tmpArray insertObject:[artistInfo valueForKey:@"artworkUrl100"]atIndex:2];
    artworkUrl100 =[tmpArray objectAtIndex:2];
    [tmpArray insertObject:[artistInfo valueForKey:@"collectionId"]atIndex:3];
    collectionId = [tmpArray objectAtIndex:3];
    [tmpArray insertObject:[artistInfo valueForKey:@"collectionName"]atIndex:4];
    collectionName = [tmpArray objectAtIndex:4];
    [tmpArray insertObject:[artistInfo valueForKey:@"trackId"]atIndex:5];
    trackId = [tmpArray objectAtIndex:5];
    [tmpArray insertObject:[artistInfo valueForKey:@"trackName"]atIndex:6];
    trackName = [tmpArray objectAtIndex:6];
    fullArtistInfo = [[NSMutableArray alloc]initWithObjects:artistId,artistName,artworkUrl100,collectionName,collectionId,trackId,trackName, nil];
    NSLog(@"newTMP string info is %@", fullArtistInfo);
    for (int i =0; i<fullArtistInfo.count; i++) {
        if (i == 0 )
        {
            NSArray *tmpArray2 = [[NSArray alloc]initWithArray:[fullArtistInfo objectAtIndex:i]];
            NSNumber *theNwewObject = [[NSNumber alloc]initWithLong:[tmpArray2 objectAtIndex:0]];
            [fullArtistInfo replaceObjectAtIndex:i withObject:theNwewObject];
            
        }
        else if (i == 4)
            {
                NSArray *tmpArray2 = [[NSArray alloc]initWithArray:[fullArtistInfo objectAtIndex:i]];
                NSNumber *theNwewObject = [[NSNumber alloc]initWithLong:[tmpArray2 objectAtIndex:0]];
                [fullArtistInfo replaceObjectAtIndex:i withObject:theNwewObject];
                
            }
        else if (i == 5 )
                {
                    NSArray *tmpArray2 = [[NSArray alloc]initWithArray:[fullArtistInfo objectAtIndex:i]];
                    NSNumber *theNwewObject = [[NSNumber alloc]initWithLong:[tmpArray2 objectAtIndex:0]];
                    [fullArtistInfo replaceObjectAtIndex:i withObject:theNwewObject];
                    
                }
        else
        {
            NSArray *tmpArray2 = [[NSArray alloc]initWithArray:[fullArtistInfo objectAtIndex:i]];
            NSString *theNwewObject = [[NSString alloc]initWithString:[tmpArray2 objectAtIndex:0]];
            [fullArtistInfo replaceObjectAtIndex:i withObject:theNwewObject];//данный массив содержит инфу о исполнителе-песне. Необходимо создать общий массив, который будет хранить все массивы в духе fullArtistInfo
            
        }
    
        
    }
    
    NSLog(@"fullArtistInfo string info is %@", fullArtistInfo);
}

-(NSMutableString*)decode:(NSMutableString*)BadSourceString
{
    [BadSourceString dataUsingEncoding:NSWindowsCP1251StringEncoding];
    NSLog(@"bad string - %@", BadSourceString);
    return BadSourceString;
}

-(void)addDataToDescriptionView
{
    //скачиваем обложку альбома
    NSString *urlString = [[NSString alloc]initWithString: [fullArtistInfo objectAtIndex:2]];
    NSURL *theNewUrl = [[NSURL alloc]initWithString:urlString];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:theNewUrl];
    [songCoverImageView setImage:[UIImage imageWithData:imageData]];
    //выставляем имя исполнителя
    NSString *artistString = [[NSString alloc]initWithString:[fullArtistInfo objectAtIndex:1]];
    songArtistLabel.text = artistString;
    //выставляем название песни
    NSString *songNameString = [[NSString alloc]initWithString:[fullArtistInfo objectAtIndex:6]];
    songNameLabel.text = songNameString;
    //выставляем альбом, к которому принадлежит песня
    NSString *albumeNameString = [[NSString alloc]initWithString:[fullArtistInfo objectAtIndex:3]];
    songAlbumNameLabel.text = albumeNameString;
    
}

@end



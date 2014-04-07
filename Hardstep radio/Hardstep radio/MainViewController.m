//
//  MainViewController.m
//  Hardstep radio
//
//  Created by Родштейн Алексей on 14.03.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import "MainViewController.h"
#import "artistClass.h"


@interface MainViewController ()
{
    artistClass *newMainArtist;
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



#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    songsDidPlayedMutableArray = [NSMutableArray new];
    iterator+=1;
    
    
#pragma mark - Stream Settings
    //Адрес потока
    NSString *stringURL = @"http://89.221.207.241:8888/";
    NSURL *streamURL = [NSURL URLWithString:stringURL];
    
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
    
    pauseButton.hidden = YES;

    //Настройки класса плеера
    asset = [AVURLAsset URLAssetWithURL:streamURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [playerItem addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
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
    descriptionContainerView = [[UIView alloc]initWithFrame:CGRectMake(320, 70,320,389)];
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
    
    
    songCoverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 150, 150)];
    songCoverImageView.backgroundColor = [UIColor blackColor];
    [descriptionContainerView addSubview:songCoverImageView];
    [descriptionContainerView bringSubviewToFront:songCoverImageView];
    
    
    
    
}

#pragma mark Functions

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
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
                    NSMutableString *tmpString = [[NSMutableString alloc]initWithString:metaItem.stringValue];
                    source = [self decode:tmpString];
                    
                    nowPlayingLabel1.text = [NSString stringWithFormat:@"%@",source];
                    nowPlayingLabel2.text = [NSString stringWithFormat:@"%@",source];
                   
                    NSLog(@"%@",source);
                }
                [self textAnimationInLabel];
                [songsDidPlayedMutableArray addObject:source];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [trackTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        }
    }
}

- (BOOL)isPlaying
{
    return [player rate] != 0.f;
}

- (void)playPause
{

}



#pragma mark Actions

- (IBAction)play:(id)sender
{
    [player play];
    playButton.hidden = YES;
    pauseButton.hidden = NO;
}

- (IBAction)pause:(id)sender
{
    [player pause];
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
             self.containerView.frame = CGRectMake(0, 500,320, 389);
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
             
             self.containerView.frame = CGRectMake(0, 179,320, 389);
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
            if ([songNameString characterAtIndex:i-1]==32) {
                [artistNameString deleteCharactersInRange:NSMakeRange(i-1, artistNameString.length-i)];
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
    for (int i = 0;i<artistNameString.length; i++) {
        if ([artistNameString characterAtIndex:i]==32)
        {
            [artistNameString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"+"];
        }
        if ([artistNameString characterAtIndex:i]==45)
        {
            [artistNameString deleteCharactersInRange:NSMakeRange(i,1)];
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
    NSLog(@"artis id is - %@",[artistInfo valueForKey:@"artistId"]);
    //NSData *artistId = [NSData dataWithContentsOfMappedFile:[artistInfo objectForKey:@"artistId"]];
    [newMainArtist setArtstID:[artistInfo objectForKey:@"artistId"]];
    [newMainArtist setArtistName:[artistInfo valueForKey:@"artistId"]];
    [newMainArtist setArtworkUrl100:[artistInfo valueForKey:@"artistId"]];
    [newMainArtist setCollectionID:[artistInfo valueForKey:@"artistId"]];
    [newMainArtist setCollectionName:[artistInfo valueForKey:@"artistId"]];
    [newMainArtist setTrackID:[artistInfo valueForKey:@"artistId"]];
    [newMainArtist setTrackName:[artistInfo valueForKey:@"artistId"]];
    //NSLog(@"artistId is - %@",artistId);
    

}

-(NSString*)decode:(NSMutableString*)BadSourceString
{
    [BadSourceString dataUsingEncoding:NSWindowsCP1251StringEncoding];
    NSLog(@"bad string - %@", BadSourceString);
    return BadSourceString;
}



@end



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
@synthesize  playButton, pauseButton, source;
@synthesize containerView;//вьюха - контейнер
@synthesize openCloseModalTableView;//кнопка
@synthesize trackTableView;//табличка
@synthesize hideShowBoolVar;//булеановские переменные
@synthesize nowPlayingLabel;//лейблы

#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //настройка фонового изображения и блюр эффекта
    //Степень размытия изображения
    //int boxsize = (int)(1.5 * 7);
    //boxsize = boxsize - (boxsize % 2) + 1;
    //Фоновое изображение
    //UIImage *backgroung = [UIImage imageNamed:@"Background.png"];
    //Применение функции размытия к нашему фону
    //UIImage *blurUmage = [self boxblurImage:backgroung boxSize:boxsize];
    //установка фонового размытого изображения
    //rootVIew.backgroundColor = [UIColor colorWithPatternImage: blurUmage];
    
    //Адрес потока
    NSString *stringURL = @"http://89.221.207.241:8888/";
    NSURL *streamURL = [NSURL URLWithString:stringURL];
    
    //настройка play/pause, логотипа и главного фона
    UIImage *backgroung = [UIImage imageNamed:@"Background.png"];
    rootVIew.backgroundColor = [UIColor colorWithPatternImage: backgroung];
    rootVIew.contentMode = UIViewContentModeScaleAspectFit;
    
    [mainLogo setImage:[UIImage imageNamed:@"logo.png"]];

    [playButton setTitle:@"" forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [pauseButton setTitle:@"" forState:UIControlStateNormal];
    [pauseButton setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
    
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
    
    
    //настройка контейнера для тейбл-вьюхи
    float heightIndent = 160.0f;
    containerView = [[UIView alloc]initWithFrame:CGRectMake(0, heightIndent, self.view.bounds.size.width, self.view.bounds.size.height)];
    containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:containerView];
    [self.view bringSubviewToFront:containerView];
    
    openCloseModalTableView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, 70)];
    [openCloseModalTableView setImage:[UIImage imageNamed:@"ButtonModal.png"] forState:UIControlStateNormal];
    openCloseModalTableView.hidden = NO;
    [openCloseModalTableView addTarget:self action:@selector(hideShowModalView) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:openCloseModalTableView];
    [containerView bringSubviewToFront:openCloseModalTableView];
    
    
    
    nowPlayingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, openCloseModalTableView.bounds.size.width, openCloseModalTableView.bounds.size.height)];
    nowPlayingLabel.text = @"";
    nowPlayingLabel.textColor = [UIColor orangeColor];
    [nowPlayingLabel setFont:[UIFont fontWithName:@"Danger" size:25.0f]];
    nowPlayingLabel.textAlignment = NSTextAlignmentCenter;
    [openCloseModalTableView addSubview:nowPlayingLabel];
    [openCloseModalTableView bringSubviewToFront:nowPlayingLabel];
    
    
    trackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, containerView.bounds.size.width, containerView.bounds.size.height) style:UITableViewStylePlain];
    //trackTableView.delegate = self;
    //trackTableView.dataSource = self;
    [trackTableView setBackgroundColor:[UIColor clearColor]];
    [containerView addSubview:trackTableView];
    [containerView bringSubviewToFront:trackTableView];
    
    hideShowBoolVar = YES;

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
                    source = metaItem.stringValue;
                    nowPlayingLabel.text = [NSString stringWithFormat:@"%@",source];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    //[trackTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self textAnimationInLabel];
                   
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

-(void)hideShowModalView //выползающий с низу модальник
{
    if (hideShowBoolVar == YES)
    {
        [UIView animateWithDuration:0.5f animations:^
         {
             self.containerView.frame = CGRectMake(0, self.view.bounds.size.height-50,self.view.bounds.size.width, self.view.bounds.size.height);
         }
         ];
        hideShowBoolVar = NO;
        
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^
         {
             self.containerView.frame = CGRectMake(0, 160,self.view.bounds.size.width, self.view.bounds.size.height);
         }
         ];
        hideShowBoolVar = YES;
        
        
    }
}

#pragma mark - TableView functions and Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newCell"];
    return newCell;
}

#pragma mark custom Functions
-(void)textAnimationInLabel
{
        [UILabel animateWithDuration:10.5f
                           delay:0.5f
                         options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse
                      animations:^
            {
                [nowPlayingLabel setFrame:CGRectMake(0-nowPlayingLabel.bounds.size.width, 0, openCloseModalTableView.bounds.size.width, openCloseModalTableView.bounds.size.height)];
            
            }
    completion:^(BOOL finished)
    {
    }];

}
@end



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
@synthesize containerView,rootVIew;//вьюха - контейнер, рут вью
@synthesize openCloseModalTableView;//кнопка
@synthesize trackTableView;//табличка
@synthesize showBoolVar;//булеановские переменные
@synthesize nowPlayingLabel1,nowPlayingLabel2;//лейблы
@synthesize mainLogo, fontLogo, backLogo;//логотипы
@synthesize songsDidPlayedMutableArray;//массивы

#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    songsDidPlayedMutableArray = [NSMutableArray new];
    
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
    
    //настройка контейнера для тейбл-вьюхи
    containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-70,self.view.bounds.size.width, self.view.bounds.size.height)];
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
//    nowPlayingLabel2.numberOfLines = 0;
//    [nowPlayingLabel2 sizeToFit];
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
    
    
    //настройка фонового изображения и блюр эффекта
    //Степень размытия изображения
    int boxsize = (int)(1.5 * 7);
    boxsize = boxsize - (boxsize % 2) + 1;
    //Фоновое изображение
    trackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, containerView.bounds.size.width, containerView.bounds.size.height) style:UITableViewStylePlain];
    trackTableView.delegate = self;
    trackTableView.dataSource = self;
    [trackTableView setBackgroundColor:[UIColor clearColor]];
    [trackTableView setContentSize:[UIImage imageNamed:@"tableViewCellPressed"].size];
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
    
    showBoolVar = NO;

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
                    nowPlayingLabel1.text = [NSString stringWithFormat:@"%@",source];
                    nowPlayingLabel2.text = [NSString stringWithFormat:@"%@",source];
                   
                    NSLog(@"%@",source);
                }
                [songsDidPlayedMutableArray addObject:source];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [trackTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self textAnimationInLabel];
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

//Метод для зазмытия изображения.
-(UIImage *)boxblurImage:(UIImage *)image boxSize:(int)boxSize
{
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error)
    {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
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
    if (showBoolVar == YES)
    {
        [UIView animateWithDuration:0.5f animations:^
         {
             self.containerView.frame = CGRectMake(0, self.view.bounds.size.height-70,self.view.bounds.size.width, self.view.bounds.size.height);
         }
         ];
        showBoolVar = NO;
        
    }
    else
    {
        
        [UIView animateWithDuration:0.5f animations:^
         {
             self.containerView.frame = CGRectMake(0, 160,self.view.bounds.size.width, self.view.bounds.size.height);
             
         }
         ];
        showBoolVar = YES;
        [self tableViewInAnimation];
        
        
    }
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
//    return [UIImage imageNamed:@"tableViewCellPressed"].size.height/2;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newCell"];
    newCell.backgroundColor = [UIColor clearColor];
    newCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableViewCell" ]];
    newCell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableViewCellPressed" ]];
    newCell.textLabel.textColor = [UIColor clearColor];
    newCell.textLabel.text = [NSString stringWithFormat:@"%@",source];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -2, newCell.bounds.size.width-50 , newCell.bounds.size.height)];
    cellLabel.text = newCell.textLabel.text;
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
                          }
                          completion:^(BOOL finished)
     {
         
     }];

}
@end



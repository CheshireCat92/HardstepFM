//
//  artistClass.h
//  Hardstep radio
//
//  Created by Cheshire on 06.04.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface artistClass : NSObject
{
   @public
    NSString *artistName;
     NSString *artworkUrl100;
     NSString *collectionName;
            NSString *trackName;
            NSString *collectionID;
            NSString *trackID;
            NSString *sourceMain;
    NSString *artistID;
}

-(void)setArtistName:(NSString*) artName;
-(void)setArtstID:(NSString*)artId;
-(void)setArtworkUrl100:(NSString*)artwork;
-(void)setCollectionName:(NSString*)collName;
-(void)setCollectionID:(NSString*)collID;
-(void)setTrackName:(NSString*)trkName;
-(void)setTrackID:(NSString*)trID;
-(void)setSourceMain:(NSString*)source;
-(NSString*)getArtistName;
-(NSString*)getArtistID;
-(NSString*)getArtWork;
-(NSString*)getCollectionName;
-(NSString*)getCollectionID;
-(NSString*)getTrackID;
-(NSString*)getTrackName;
-(NSString*)getSource;

@end

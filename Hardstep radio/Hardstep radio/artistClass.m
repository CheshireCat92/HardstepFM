//
//  artistClass.m
//  Hardstep radio
//
//  Created by Cheshire on 06.04.14.
//  Copyright (c) 2014 Alex Rodshtein. All rights reserved.
//

#import "artistClass.h"

@implementation artistClass

#pragma mark - Setters

-(void)setArtistName:(NSString*) artName
{
    artistName = artName ;
}

-(void)setArtstID:(NSString*)artId
{
    artistID = artId;
}
-(void)setArtworkUrl100:(NSString*)artwork
{
    
    artworkUrl100 =artwork;
}

-(void)setTrackID:(NSString*)trID
{
    trackID = trID;
}

-(void)setTrackName:(NSString*)trkName
{
    trackName = trkName;
}

-(void)setCollectionName:(NSString*)collName
{
    collectionName = collName;
}

-(void)setCollectionID:(NSString*)collID
{
    collectionID = collID;
}
-(void)setSourceMain:(NSString *)source
{
    sourceMain = source;
}

#pragma mark - Getters

-(NSString *)getArtistID
{
    return artistID;
}

-(NSString *)getArtistName
{
    return artistName;
}

-(NSString *)getArtWork
{
    return artworkUrl100;
}

-(NSString *)getCollectionID
{
    return collectionID;
}
-(NSString *)getCollectionName
{
    return collectionName;
}
-(NSString *)getTrackID
{
    return trackID;
}
-(NSString *)getTrackName
{
    return trackName;
}
-(NSString *)getSource
{
    return sourceMain;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
@end

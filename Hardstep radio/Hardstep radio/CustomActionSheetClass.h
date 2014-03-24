//
//  CustomActionSheetClass.h
//  KupiBobra
//
//  Created by Cheshire on 28.04.13.
//  Copyright (c) 2013 Cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageClass.h"



@class  CustomActionSheetClass;

@protocol  CustomActionSheetDelegate  <NSObject>

-(void) customActionSheetButton:(UIButton *) actionSheet didChangeSettings:(id)settings; 

@end

static NSComparisonResult sortingCustomObjectNames (StorageClass *object1 ,StorageClass *object2, void *ignore)
{
    return [object1.cellName localizedCompare: object2.cellName];
}

static NSComparisonResult sortingCustomObjectColors (StorageClass *object1 ,StorageClass *object2, void *ignore)
{
    float red,green,blue, alpha;
    
    [object1.cellColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    float red2, green2, blue2, alpha2;
    
    [object2.cellColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    if (red < red2) return NSOrderedAscending;
    else if (red > red2) return NSOrderedDescending;
    
    if (green < green2) return NSOrderedAscending;
    else if (green > green2) return NSOrderedDescending;
    
    if (blue < blue2) return NSOrderedAscending;
    else if (blue > blue2) return NSOrderedDescending;
    
    return NSOrderedSame;
    
}


@interface CustomActionSheetClass : UIActionSheet <UITableViewDelegate,UITableViewDataSource, CustomActionSheetDelegate>
{
    StorageClass *_storCell;
    UITableView *_purchaseTableView;
    UIActionSheet *_testSheet;
    NSMutableArray *_purchaselist;
    NSMutableArray *_colorArray ;
    StorageClass *_cellData;
    NSMutableArray *_sortingPurchaseList;
    UIButton *_closeSheetButton;
    UIButton *_saveDataFromSheetButton;
    UIButton *_alphSortButton;
    UIButton *_colorSortButton;
    UIButton *_redPicButton;
    UIButton *_bluePicButton;
    UIButton *_greenPicButton;
    UIButton *_yellowPicButton;
    UIButton *_orangePicButton;

    
    
}


@property (nonatomic,assign) id <CustomActionSheetDelegate> customDelegate;




@end

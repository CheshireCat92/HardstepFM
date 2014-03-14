//
//  CustomActionSheetClass.m
//  KupiBobra
//
//  Created by Cheshire on 28.04.13.
//  Copyright (c) 2013 Cheshire. All rights reserved.
//

#import "CustomActionSheetClass.h"


@interface CustomActionSheetClass () <UITableViewDataSource,UITableViewDelegate>
{
        
    
}

@end




@implementation CustomActionSheetClass



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _storCell = [[StorageClass alloc] init];
        _sortingPurchaseList = [[NSMutableArray alloc] init];
        
        
        _purchaselist = [[NSMutableArray alloc] initWithObjects:@"Котлеты",@"Отбивные",@"Минералка",@"Газировка",@"Зелень",@"Лук",@"Яблоки",@"Виноград",@"печеньки",@"конфетки",nil];
        
        _colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor redColor],[UIColor redColor],[UIColor colorWithRed:0.231 green:0.639 blue:0.816 alpha:1],[UIColor colorWithRed:0.231 green:0.639 blue:0.816 alpha:1],[UIColor greenColor],[UIColor greenColor],[UIColor yellowColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor orangeColor], nil];
        
        
        
        int counter = 0;
        while ( counter != [_purchaselist count])
        {
            StorageClass *cellForSort = [[StorageClass alloc] init];
            [cellForSort setCellName:[_purchaselist objectAtIndex:counter]];
//            NSLog(@"имя %@",cellForSort.cellName);
            [cellForSort setCellColor:[_colorArray objectAtIndex:counter]];
//            NSLog(@"цвет %@",cellForSort.cellColor);
            [_sortingPurchaseList insertObject:cellForSort atIndex:counter];
            counter++;
//            NSLog(@"i равно %d",counter);
        }
        
        NSLog(@"выводим сортировочный массив -> %@", _sortingPurchaseList);
        
        _testSheet = [[UIActionSheet alloc] init];
        _closeSheetButton = [[UIButton alloc] init];
        _saveDataFromSheetButton = [[UIButton alloc] init];
        _alphSortButton = [[UIButton alloc] init];
        _colorSortButton = [[UIButton alloc] init];
        _redPicButton = [[UIButton alloc] init];
        _bluePicButton = [[UIButton alloc] init];
        _greenPicButton = [[UIButton alloc] init];
        _yellowPicButton = [[UIButton alloc] init];
        _orangePicButton = [[UIButton alloc] init];
        
        
    }
    return self;
}


-(void) viewDidLoad
{
    
}

#pragma mark ActionSheet


- (void)drawRect:(CGRect)rect
{
    
    [_testSheet showInView:self];
    [_testSheet setFrame:CGRectMake(0, 100, 320, 380)];
    
    
    _closeSheetButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _closeSheetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _closeSheetButton.tag = 0;
    _closeSheetButton.hidden = NO;
    _closeSheetButton.backgroundColor = [UIColor clearColor];
    _closeSheetButton.opaque = NO;
    _closeSheetButton.frame = CGRectMake(266.0, 2.0, 55.0, 30.0);
    [_closeSheetButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeSheetButton addTarget:self action:@selector(closeActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_closeSheetButton];
    
    
    _saveDataFromSheetButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _saveDataFromSheetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveDataFromSheetButton.tag = 1;
    _saveDataFromSheetButton.hidden = NO;
    _saveDataFromSheetButton.backgroundColor = [UIColor clearColor];
    _saveDataFromSheetButton.opaque = NO;
    _saveDataFromSheetButton.frame = CGRectMake(0.0, 2.0, 55.0, 30.0);
    [_saveDataFromSheetButton setTitle:@"Save" forState:UIControlStateNormal];
    [_saveDataFromSheetButton addTarget:self action:@selector(saveDataFromSheet:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_saveDataFromSheetButton];
    
    
    _alphSortButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _alphSortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _alphSortButton.tag = 2;
    _alphSortButton.hidden = NO;
    _alphSortButton.backgroundColor = [UIColor clearColor];
    _alphSortButton.opaque = NO;
    _alphSortButton.frame = CGRectMake(140.0, 2.0, 55.0, 30.0);
    [_alphSortButton setTitle:@"ABC's" forState:UIControlStateNormal];
    [_alphSortButton addTarget:self action:@selector(alphSort:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_alphSortButton];
    
    
    _colorSortButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _colorSortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _colorSortButton.tag = 3;
    _colorSortButton.hidden = NO;
    _colorSortButton.backgroundColor = [UIColor clearColor];
    _colorSortButton.opaque = NO;
    _colorSortButton.frame = CGRectMake(70.0, 2.0, 55.0, 30.0);
    [_colorSortButton setTitle:@"Color" forState:UIControlStateNormal];
    [_colorSortButton addTarget:self action:@selector(colorSort:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_colorSortButton];
    
    
    _purchaseTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _purchaseTableView.hidden = NO;
    _purchaseTableView.backgroundColor = [UIColor whiteColor];
    _purchaseTableView.opaque = NO;
    _purchaseTableView.tag = 10;
    _purchaseTableView.frame = CGRectMake(0, 70, 320, 310);
    _purchaseTableView.showsHorizontalScrollIndicator = NO;
    _purchaseTableView.showsVerticalScrollIndicator = NO;
    _purchaseTableView.delegate = self;
    _purchaseTableView.dataSource = self;
    [_purchaseTableView reloadData];
    
    [_testSheet addSubview:_purchaseTableView];
    
    
    
    
    _redPicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _redPicButton.tag = 10;
    _redPicButton.hidden = NO;
    _redPicButton.backgroundColor = [UIColor redColor];
    _redPicButton.opaque = NO;
    _redPicButton.frame = CGRectMake(0.0, 35.0, 55.0, 30.0);
    [_redPicButton setTitle:@"" forState:UIControlStateNormal];
    [_redPicButton addTarget:self action:@selector(PicButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_redPicButton];
    
    
    _bluePicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _bluePicButton.tag = 11;
    _bluePicButton.hidden = NO;
    _bluePicButton.backgroundColor = [UIColor colorWithRed:0.231 green:0.639 blue:0.816 alpha:1] /*цвет воды*/;
    _bluePicButton.opaque = NO;
    _bluePicButton.frame = CGRectMake(65.0, 35.0, 55.0, 30.0);
    [_bluePicButton setTitle:@"" forState:UIControlStateNormal];
    [_bluePicButton addTarget:self action:@selector(PicButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_bluePicButton];
    
    
    _greenPicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _greenPicButton.tag = 12;
    _greenPicButton.hidden = NO;
    _greenPicButton.backgroundColor = [UIColor greenColor];
    _greenPicButton.opaque = NO;
    _greenPicButton.frame = CGRectMake(135.0, 35.0, 55.0, 30.0);
    [_greenPicButton setTitle:@"" forState:UIControlStateNormal];
    [_greenPicButton addTarget:self action:@selector(PicButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_greenPicButton];
    
    
    _yellowPicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _yellowPicButton.tag = 13;
    _yellowPicButton.hidden = NO;
    _yellowPicButton.backgroundColor = [UIColor yellowColor];
    _yellowPicButton.opaque = NO;
    _yellowPicButton.frame = CGRectMake(205.0, 35.0, 55.0, 30.0);
    [_yellowPicButton setTitle:@"" forState:UIControlStateNormal];
    [_yellowPicButton addTarget:self action:@selector(PicButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_yellowPicButton];
    
    
    _orangePicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _orangePicButton.tag = 14;
    _orangePicButton.hidden = NO;
    _orangePicButton.backgroundColor = [UIColor orangeColor];
    _orangePicButton.opaque = NO;
    _orangePicButton.frame = CGRectMake(270.0, 35.0, 50.0, 30.0);
    [_orangePicButton setTitle:@"" forState:UIControlStateNormal];
    [_orangePicButton addTarget:self action:@selector(PicButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [_testSheet addSubview:_orangePicButton];
    
}

-(void)closeActionSheet:(UIButton*)sender
{
    if (_testSheet.isVisible == YES)
    {
        [_testSheet dismissWithClickedButtonIndex:sender.tag animated:YES];
        [self dismissWithClickedButtonIndex:sender.tag animated:YES];
    }
    
    
    
}


-(void)saveDataFromSheet:(UIButton*)sender //вызов делегата
{
    
    if ([self.customDelegate respondsToSelector:@selector(customActionSheetButton:didChangeSettings:)])
        
    {
        if (_storCell.cellColor == nil)
            
        {
            [_storCell setCellColor:[UIColor whiteColor]];
        }
        
        [self.customDelegate customActionSheetButton:sender didChangeSettings:_storCell];
        NSLog(@" storCell %@",_storCell.cellName);
    }
    

}

-(void)alphSort:(UIButton*)sender
{
    
    [_sortingPurchaseList sortUsingFunction:sortingCustomObjectNames context:nil];
    
    [_purchaseTableView reloadData];
}

-(void)colorSort:(UIButton*)sender
{
    [_sortingPurchaseList sortUsingFunction:sortingCustomObjectColors context: nil];
    
    [_purchaseTableView reloadData];
}

-(void)PicButtonSelector:(UIButton*)sender
{
    [_storCell setCellColor:sender.backgroundColor];
    
    NSLog(@" передаваемый цвет -> %@", _storCell.cellColor);
}





#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView //возвращает кол-во секций
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section //возвращает кол-во строк
{
    
    
    return [_sortingPurchaseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  //настройка отображаемых строк
{
    
    
    
    NSString *cellident = @"cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
    
    cell.opaque = YES;
    
    cell.alpha = 1;
    
    
    if (!cell)
        
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
        
        cell.opaque = YES;
        
        cell.alpha = 1;
        
        
        
    }
    
    StorageClass *reData = [[StorageClass alloc] init];
    
    reData = [_sortingPurchaseList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [reData cellName];
    
    cell.backgroundColor = [reData cellColor];
    
    cell.contentView.backgroundColor = [reData cellColor];
        
    return cell;
    
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  //настройка заголовка секций
{
    return 0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  //настройка поведения строк по нажатию на них
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    StorageClass *tempObject = [[StorageClass alloc] init];
    
    if (cell.isSelected)
        
    {   
        
        tempObject = [_sortingPurchaseList objectAtIndex:indexPath.row];
        
        [_storCell setCellName:tempObject.cellName];
        
        [_storCell setCellColor:tempObject.cellColor];
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void) customActionSheetButton:(UIButton *) actionSheet didChangeSettings:(id)settings
{
    
}

@end

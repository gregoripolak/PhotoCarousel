//
//  CarouselViewController.m
//  PhotoCarousel
//
//  Created by Gil Polak on 2/20/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import "CarouselViewController.h"
#import "CarouselCVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define heightRatioToScreenPortrait 6
#define heightRatioToScreenLandscape 3

@interface CarouselViewController()

@property (nonatomic, strong) NSMutableDictionary *selectedImagesDict;

@end

@implementation CarouselViewController

#pragma Properties Init.

@synthesize selectedImagesDict = _selectedImagesDict;

- (NSMutableDictionary *)selectedImagesDict
{
    if (_selectedImagesDict == nil) {
        _selectedImagesDict = [[NSMutableDictionary alloc] init];
    }
    
    return _selectedImagesDict;
}

- (NSArray *) imageNameArray
{
    if (_imageNameArray == nil) {
        _imageNameArray = @[@"Image1", @"Image2", @"Image3", @"Image4", @"Image5", @"Image6", @"Image7", @"Image8", @"Image9", @"Image10"];
    }
    
    return _imageNameArray;
}

#pragma mark - View handling

- (void) viewDidLoad
{
    self.CarouselCollectionView.allowsMultipleSelection = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - CollectionView DS implementaion

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.imageNameArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarouselCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewer" forIndexPath:indexPath];
    
    __block NSString *imageLocalName = (NSString *)[self.imageNameArray objectAtIndex:[indexPath section]];

    //cell.imageView.image = [UIImage imageNamed:imageLocalName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageNamed:imageLocalName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // assign cell image on main thread
            cell.imageView.image = img;
        });
    });

    
    cell.photoSelectedView.imageSelected = [self.selectedImagesDict objectForKey:indexPath] != nil ? YES : NO;
    
    return cell;
}

#pragma mark - CollectionView Delegate implementaion

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = [self.imageNameArray objectAtIndex:[indexPath section]];
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat height;
    if(self.view.bounds.size.height > self.view.bounds.size.width)
        height = self.view.bounds.size.height / heightRatioToScreenPortrait;
    else
        height = self.view.bounds.size.height / heightRatioToScreenLandscape;
    CGFloat width = image.size.width * (height / image.size.height);
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedImagesDict setObject:[self.imageNameArray objectAtIndex:indexPath.row] forKey:indexPath];
    
    CarouselCVC *cell = (CarouselCVC *)[self.CarouselCollectionView cellForItemAtIndexPath:indexPath];
    cell.photoSelectedView.imageSelected = YES;
    [self updateUI];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedImagesDict removeObjectForKey:indexPath];
    
    CarouselCVC *cell = (CarouselCVC *)[self.CarouselCollectionView cellForItemAtIndexPath:indexPath];
    cell.photoSelectedView.imageSelected = NO;
    [self updateUI];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat heightInset;
    
    if(self.view.bounds.size.height > self.view.bounds.size.width)
        heightInset = (self.view.bounds.size.height / 2) - ((self.view.bounds.size.height / heightRatioToScreenPortrait) / 2);
    else
        heightInset = (self.view.bounds.size.height / 2) - ((self.view.bounds.size.height / heightRatioToScreenLandscape) / 2);
    
    CGFloat leftInset = (section == 0) ? 0 : 10;
    return UIEdgeInsetsMake(heightInset, leftInset, heightInset, 0);
}

#pragma mark - UI Handling

- (void) updateUI
{
    self.navigationItem.title = [NSString stringWithFormat:@"%lu Photos Selected", (unsigned long)[self.selectedImagesDict count]];
}

@end

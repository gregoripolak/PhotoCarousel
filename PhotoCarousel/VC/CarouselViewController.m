//
//  CarouselViewController.m
//  PhotoCarousel
//
//  Created by Gil Polak on 2/20/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import "CarouselViewController.h"
#import "CarouselCVC.h"
#import <Photos/Photos.h>

#define heightRatioToScreenPortrait 6
#define heightRatioToScreenLandscape 3

@interface CarouselViewController()

@property (nonatomic, strong) NSMutableDictionary *selectedImagesDict;
@property (nonatomic, strong) NSMutableArray *assets;

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

- (NSMutableArray *)assets
{
    if (_assets == nil)
    {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
        _assets = [[NSMutableArray alloc] init];
        for(PHAsset *asset in fetchResult)
        {
            [_assets insertObject:asset atIndex:[_assets count]];
        }
    }
    
    return _assets;
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
    return self.assets.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = @"ImageViewer";
    CarouselCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:[self.assets objectAtIndex:indexPath.section] targetSize:CGSizeMake(800, 600) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info)
     {
         cell.imageView.image = result;
     }];
    
    cell.photoSelectedView.imageSelected = [self.selectedImagesDict objectForKey:indexPath] != nil ? YES : NO;
    
    return cell;
}

#pragma mark - CollectionView Delegate implementaion

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block UIImage *image;

    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:[self.assets objectAtIndex:indexPath.section] targetSize:CGSizeMake(800, 600) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info)
     {
         image = result;
     }];
    
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
    [self.selectedImagesDict setObject:[self.assets objectAtIndex:indexPath.section] forKey:indexPath];
    
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarouselCVC *CCell = (CarouselCVC *)cell;
    
    [CCell detirminePhotoSelectedViewPosition];
}

#pragma mark - UI Handling

- (void) updateUI
{
    NSUInteger numberOfPhotosSelected = [self.selectedImagesDict count];
    if (numberOfPhotosSelected == 0)
    {
        self.navigationItem.title = @"Select Items";
    }
    else if (numberOfPhotosSelected == 1)
    {
        self.navigationItem.title = @"1 Photo Selected";
    }
    else if (numberOfPhotosSelected > 1)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%lu Photos Selected", numberOfPhotosSelected];
    }
}

@end

//
//  CarouselViewController.h
//  PhotoCarousel
//
//  Created by Gil Polak on 2/20/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *CarouselCollectionView;
@property (strong, nonatomic) NSArray *imageNameArray;

@end

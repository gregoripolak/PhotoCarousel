//
//  CarouselCVC.h
//  PhotoCarousel
//
//  Created by Gil Polak on 2/21/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSelectedView.h"

@interface CarouselCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PhotoSelectedView *photoSelectedView;

- (void) detirminePhotoSelectedViewPosition;

@end

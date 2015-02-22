//
//  CarouselCVC.m
//  PhotoCarousel
//
//  Created by Gil Polak on 2/21/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import "CarouselCVC.h"
#import "CarouselViewController.h"

#define defaultSpacing 8

@implementation CarouselCVC


- (void)didMoveToWindow
{
    [self.superview addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)dealloc
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self detirminePhotoSelectedViewPosition];
    }
}

- (void) detirminePhotoSelectedViewPosition
{
    CGFloat scrollOffsetX = [((UIScrollView *)self.superview) contentOffset].x;
    CGFloat scrollWidth = self.superview.bounds.size.width;
    CGFloat screenPostOnScreen = scrollWidth + scrollOffsetX;
    CGFloat relative = self.frame.origin.x + self.frame.size.width - screenPostOnScreen;
    CGFloat newXPos;
    
    if(relative > 0)
    {
        if (relative > self.frame.size.width - self.photoSelectedView.frame.size.width - (defaultSpacing*2))
        {
            newXPos = 8;
        }
        else
        {
            newXPos = self.frame.size.width - relative - self.photoSelectedView.frame.size.width - defaultSpacing;
        }
        
    }
    else
    {
        newXPos = self.frame.size.width - self.photoSelectedView.frame.size.width - defaultSpacing;
    }
    self.photoSelectedView.frame = CGRectMake(newXPos, self.photoSelectedView.frame.origin.y,
                                              self.photoSelectedView.frame.size.width, self.photoSelectedView.frame.size.height);
//    [self setNeedsDisplay];
}

@end

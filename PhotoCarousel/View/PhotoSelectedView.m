//
//  PhotoSelectedView.m
//  PhotoCarousel
//
//  Created by Gil Polak on 2/20/15.
//  Copyright (c) 2015 Gregori Polak. All rights reserved.
//

#import "PhotoSelectedView.h"

@interface PhotoSelectedView ()

@property (strong, nonatomic) UILabel *label;

@end


@implementation PhotoSelectedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        _imageSelected = NO;
        
        self.layer.cornerRadius = self.bounds.size.width / 2;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self addSubview: self.label];
    }
    
    return self;
}

- (UILabel *)label
{
    if (_label == nil)
    {
        CGRect rect = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
        UILabel *initLabel = [[UILabel alloc] initWithFrame:rect];
        initLabel.textAlignment = NSTextAlignmentCenter;
        [initLabel setTextColor:[UIColor whiteColor]];
        initLabel.font = [UIFont systemFontOfSize:24.0];
        _label = initLabel;
    }
    
    return _label;
}

- (void)setImageSelected:(BOOL)imageSelected
{
    _imageSelected = imageSelected;
    
    [self updateUI];
}


- (void) updateUI
{
    // Allways
    
    // Depending on imageSelected or not
    if (self.imageSelected)
    {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.label.text = @"✓";
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.label.text = @"";
    }
}

@end

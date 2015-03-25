//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Hefang Li on 8/21/14.
//  Copyright (c) 2014 hfl. All rights reserved.
//

#import "SIGSmallCollectionCell.h"
#import "SIGPhotoController.h"

@implementation SIGSmallCollectionCell

- (void)setPost:(NSDictionary *)post
{
    _post = post;
    
    [SIGPhotoController imageForPost:_post size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

@end

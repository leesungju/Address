//
//  SLZoomingImageView.h
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TapDetecting.h"

@interface ZoomingImageView : UIScrollView <UIScrollViewDelegate, TapDetectingViewDelegate>

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) UIImage* image;

- (void)prepareForReuse;
- (void)setMaxMinZoomScalesForCurrentBounds;

@end

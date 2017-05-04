//
//  SLZoomingImageView.m
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import "ZoomingImageView.h"
#import "AsyncImageView.h"

@interface ZoomingImageView ()
{
    BOOL isHiddenView;
    BOOL isZooming;
}
@property (nonatomic, strong) UIView* tapView;
@property (nonatomic, strong) AsyncImageView* tapImageView;
@end

@implementation ZoomingImageView
@synthesize index = _index;
@synthesize tapView = _tapView;
@synthesize tapImageView = _tapImageView;
@synthesize imageURL = _imageURL;
@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTapView];
        [self setupTapImageView];
        isHiddenView = NO;
        isZooming = NO;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)layoutSubviews {
    
    _tapView.frame = self.bounds;
    
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _tapImageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(_tapImageView.frame, frameToCenter)){
        _tapImageView.frame = frameToCenter;
    }
    
}

#pragma mark - Public Methods
- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    [self displayImage];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self displayImage];
}

- (void)prepareForReuse
{
    _tapImageView.image = nil;
    _index = NSUIntegerMax;
}

#pragma mark - setup Views
- (void)setupTapView
{
    if(_tapView == nil){
        _tapView = [[UIView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
    }
}

- (void)setupTapImageView
{
    if(_tapImageView == nil){
        _tapImageView = [[AsyncImageView alloc] initWithFrame:self.bounds];
        _tapImageView.tapDelegate = self;
        _tapImageView.contentMode = UIViewContentModeCenter;
        _tapImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapImageView];
    }
}

#pragma mark - Display
- (void)displayImage
{
    if (_imageURL) {
        
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeMake(0, 0);
        
        __weak AsyncImageView* wImageView = _tapImageView;
        __weak ZoomingImageView* wSelf = self;
        
        [_tapImageView setImageURLString:_imageURL
                                 success:^(UIImage *img) {
                                     CGRect photoImageViewFrame;
                                     photoImageViewFrame.origin = CGPointZero;
                                     photoImageViewFrame.size = img.size;
                                     wImageView.frame = photoImageViewFrame;
                                     wSelf.contentSize = photoImageViewFrame.size;
                                     [wSelf setMaxMinZoomScalesForCurrentBounds];
                                     [wSelf setNeedsLayout];
                                 }
                                   error:^(NSError *error, NSURL *url) {

                                   }];
        
        _tapImageView.hidden = NO;
        [self setMaxMinZoomScalesForCurrentBounds];
        
    }
    else if (_image) {
        
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeMake(0, 0);
        
        [_tapImageView setImage:_image];
        _tapImageView.hidden = NO;
        
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = _image.size;
        _tapImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        [self setMaxMinZoomScalesForCurrentBounds];
        [self setNeedsLayout];
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_tapImageView) {
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _tapImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;
        CGFloat yScale = boundsSize.height / imageSize.height;
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return 1;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    if (_tapImageView.image == nil) return;
    
    _tapImageView.frame = CGRectMake(0, 0, _tapImageView.frame.size.width, _tapImageView.frame.size.height);
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _tapImageView.image.size;
    
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat maxScale = 3;
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    if (self.zoomScale != minScale) {
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        self.scrollEnabled = NO;
    }
    
    [self setNeedsLayout];
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _tapImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
    
//    if(!isHiddenView){
//        if  ([_zoomDelegate respondsToSelector:@selector(zoomingImageView:isHiddenView:)]){
//            [_zoomDelegate zoomingImageView:self isHiddenView:isHiddenView];
//            isHiddenView = YES;
//        }
//    }else{
//        if  ([_zoomDelegate respondsToSelector:@selector(zoomingImageView:isHiddenView:)]){
//            [_zoomDelegate zoomingImageView:self isHiddenView:isHiddenView];
//            isHiddenView = NO;
//        }
//    }
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
        isZooming = NO;
    } else {
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        isZooming = YES;
    }
}

#pragma mark - TapDetectingView Delegate methods

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch
{
    if(!isZooming){
        if([view isEqual:_tapView]){
            CGFloat touchX = [touch locationInView:view].x;
            CGFloat touchY = [touch locationInView:view].y;
            touchX *= 1/self.zoomScale;
            touchY *= 1/self.zoomScale;
            touchX += self.contentOffset.x;
            touchY += self.contentOffset.y;
            [self handleSingleTap:CGPointMake(touchX, touchY)];
        }
        else{
            [self handleSingleTap:[touch locationInView:view]];
        }
    }
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch
{
    if([view isEqual:_tapView]){
        CGFloat touchX = [touch locationInView:view].x;
        CGFloat touchY = [touch locationInView:view].y;
        touchX *= 1/self.zoomScale;
        touchY *= 1/self.zoomScale;
        touchX += self.contentOffset.x;
        touchY += self.contentOffset.y;
        [self handleDoubleTap:CGPointMake(touchX, touchY)];
    }
    else{
        [self handleDoubleTap:[touch locationInView:view]];
    }
}

@end

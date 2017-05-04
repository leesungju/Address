//
//  SLAsyncImageView.h
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


extern NSString *const AsyncImageLoadDidFinish;
extern NSString *const AsyncImageLoadDidFail;

extern NSString *const AsyncImageImageKey;
extern NSString *const AsyncImageURLKey;
extern NSString *const AsyncImageCacheKey;
extern NSString *const AsyncImageErrorKey;


@interface AsyncImageLoader : NSObject

+ (AsyncImageLoader *)sharedLoader;
+ (NSCache *)defaultCache;

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, assign) NSUInteger concurrentLoads;
@property (nonatomic, assign) NSTimeInterval loadingTimeout;

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)loadImageWithURL:(NSURL *)URL;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target;
- (void)cancelLoadingURL:(NSURL *)URL;
- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action;
- (void)cancelLoadingImagesForTarget:(id)target;
- (NSURL *)URLForTarget:(id)target action:(SEL)action;
- (NSURL *)URLForTarget:(id)target;

@end

@interface UIImageView(AsyncImageView)

@property (nonatomic, strong) NSURL *imageURL;

@end

typedef void (^AsyncImageViewSuccessCallback)(UIImage* img);
typedef void (^AsyncImageViewErrorCallback)(NSError* error, NSURL* url);

@interface AsyncImageView : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
@property (nonatomic, assign) NSTimeInterval crossfadeDuration;

- (void)setImageURLString:(NSString *)imageURLString success:(AsyncImageViewSuccessCallback)successCallback error:(AsyncImageViewErrorCallback)errorCallback;

@end

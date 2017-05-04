//
//  SLAsyncImageView.m
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import "AsyncImageView.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

NSString *const AsyncImageLoadDidFinish = @"AsyncImageLoadDidFinish";
NSString *const AsyncImageLoadDidFail = @"AsyncImageLoadDidFail";

NSString *const AsyncImageImageKey = @"image";
NSString *const AsyncImageURLKey = @"URL";
NSString *const AsyncImageCacheKey = @"cache";
NSString *const AsyncImageErrorKey = @"error";


@interface AsyncImageConnection : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL success;
@property (nonatomic, assign) SEL failure;
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, getter = isCancelled) BOOL cancelled;

- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
                               target:(id)target
                              success:(SEL)success
                              failure:(SEL)failure;

- (void)start;
- (void)cancel;
- (BOOL)isInCache;

@end


@implementation AsyncImageConnection

- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
                               target:(id)target
                              success:(SEL)success
                              failure:(SEL)failure
{
    if ((self = [self init]))
    {
        self.URL = URL;
        self.cache = cache;
        self.target = target;
        self.success = success;
        self.failure = failure;
    }
    return self;
}

- (UIImage *)cachedImage
{
    if ([self.URL isFileURL])
    {
        NSString *path = [[self.URL absoluteURL] path];
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        if ([path hasPrefix:resourcePath])
        {
            return [UIImage imageNamed:[path substringFromIndex:[resourcePath length]]];
        }
    }
    return [self.cache objectForKey:self.URL];
}

- (BOOL)isInCache
{
    return [self cachedImage] != nil;
}

- (void)loadFailedWithError:(NSError *)error
{
    self.loading = NO;
    self.cancelled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFail
                                                        object:self.target
                                                      userInfo:@{AsyncImageURLKey: self.URL,
                                                                 AsyncImageErrorKey: error}];
}

- (void)cacheImage:(UIImage *)image
{
    if (!self.cancelled)
    {
        if (image && self.URL)
        {
            BOOL storeInCache = YES;
            if ([self.URL isFileURL])
            {
                if ([[[self.URL absoluteURL] path] hasPrefix:[[NSBundle mainBundle] resourcePath]])
                {
                    storeInCache = NO;
                }
            }
            if (storeInCache)
            {
                [self.cache setObject:image forKey:self.URL];
            }
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         image, AsyncImageImageKey,
                                         self.URL, AsyncImageURLKey,
                                         nil];
        if (self.cache)
        {
            userInfo[AsyncImageCacheKey] = self.cache;
        }
        
        self.loading = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFinish
                                                            object:self.target
                                                          userInfo:[userInfo copy]];
    }
    else
    {
        self.loading = NO;
        self.cancelled = NO;
    }
}

- (void)processDataInBackground:(NSData *)data
{
    @synchronized ([self class])
    {
        if (!self.cancelled)
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            if (image)
            {
                UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
                [image drawAtPoint:CGPointZero];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [self performSelectorOnMainThread:@selector(cacheImage:)
                                       withObject:image
                                    waitUntilDone:YES];
            }
            else
            {
                @autoreleasepool
                {
                    NSError *error = [NSError errorWithDomain:@"AsyncImageLoader" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Invalid image data"}];
                    [self performSelectorOnMainThread:@selector(loadFailedWithError:) withObject:error waitUntilDone:YES];
                }
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(cacheImage:)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (void)connection:(__unused NSURLConnection *)connection didReceiveResponse:(__unused NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(__unused NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(__unused NSURLConnection *)connection
{
    [self performSelectorInBackground:@selector(processDataInBackground:) withObject:self.data];
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(__unused NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    [self loadFailedWithError:error];
}

- (void)start
{
    if (self.loading && !self.cancelled)
    {
        return;
    }
    
    self.loading = YES;
    self.cancelled = NO;
    
    if (self.URL == nil)
    {
        [self cacheImage:nil];
        return;
    }
    
    UIImage *image = [self cachedImage];
    if (image)
    {
        //add to cache (cached already but it doesn't matter)
        [self performSelectorOnMainThread:@selector(cacheImage:)
                               withObject:image
                            waitUntilDone:NO];
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:[AsyncImageLoader sharedLoader].loadingTimeout];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
}

- (void)cancel
{
    self.cancelled = YES;
    [self.connection cancel];
    self.connection = nil;
    self.data = nil;
}

@end


@interface AsyncImageLoader ()

@property (nonatomic, strong) NSMutableArray *connections;

@end


@implementation AsyncImageLoader

+ (AsyncImageLoader *)sharedLoader
{
    static AsyncImageLoader *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [(AsyncImageLoader *)[self alloc] init];
    }
    return sharedInstance;
}

+ (NSCache *)defaultCache
{
    static NSCache *sharedCache = nil;
    if (sharedCache == nil)
    {
        sharedCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *note) {
            
            [sharedCache removeAllObjects];
        }];
    }
    return sharedCache;
}

- (AsyncImageLoader *)init
{
    if ((self = [super init]))
    {
        self.cache = [[self class] defaultCache];
        _concurrentLoads = 2;
        _loadingTimeout = 20.0;
        _connections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageLoaded:)
                                                     name:AsyncImageLoadDidFinish
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageFailed:)
                                                     name:AsyncImageLoadDidFail
                                                   object:nil];
    }
    return self;
}

- (void)updateQueue
{
    NSUInteger count = 0;
    for (AsyncImageConnection *connection in self.connections)
    {
        if (![connection isLoading])
        {
            if ([connection isInCache])
            {
                [connection start];
            }
            else if (count < self.concurrentLoads)
            {
                count ++;
                [connection start];
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{
    NSURL *URL = (notification.userInfo)[AsyncImageURLKey];
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.URL == URL || [connection.URL isEqual:URL])
        {
            for (NSInteger j = i - 1; j >= 0; j--)
            {
                AsyncImageConnection *earlier = self.connections[(NSUInteger)j];
                if (earlier.target == connection.target &&
                    earlier.success == connection.success)
                {
                    [earlier cancel];
                    [self.connections removeObjectAtIndex:(NSUInteger)j];
                    i--;
                }
            }
            
            [connection cancel];
            
            UIImage *image = (notification.userInfo)[AsyncImageImageKey];
            ((void (*)(id, SEL, id, id))objc_msgSend)(connection.target, connection.success, image, connection.URL);
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
    
    [self updateQueue];
}

- (void)imageFailed:(NSNotification *)notification
{
    NSURL *URL = (notification.userInfo)[AsyncImageURLKey];
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL])
        {
            [connection cancel];
            if (connection.failure)
            {
                NSError *error = (notification.userInfo)[AsyncImageErrorKey];
                ((void (*)(id, SEL, id, id))objc_msgSend)(connection.target, connection.failure, error, URL);
            }
            
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
    
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure
{
    UIImage *image = [self.cache objectForKey:URL];
    if (image)
    {
        [self cancelLoadingImagesForTarget:self action:success];
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                ((void (*)(id, SEL, id, id))objc_msgSend)(target, success, image, URL);
            });
        }
        return;
    }
    
    AsyncImageConnection *connection = [[AsyncImageConnection alloc] initWithURL:URL
                                                                           cache:self.cache
                                                                          target:target
                                                                         success:success
                                                                         failure:failure];
    BOOL added = NO;
    for (NSUInteger i = 0; i < [self.connections count]; i++)
    {
        AsyncImageConnection *existingConnection = self.connections[i];
        if (!existingConnection.loading)
        {
            [self.connections insertObject:connection atIndex:i];
            added = YES;
            break;
        }
    }
    if (!added)
    {
        [self.connections addObject:connection];
    }
    
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    [self loadImageWithURL:URL target:target success:action failure:NULL];
}

- (void)loadImageWithURL:(NSURL *)URL
{
    [self loadImageWithURL:URL target:nil success:NULL failure:NULL];
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL] && connection.target == target && connection.success == action)
        {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL] && connection.target == target)
        {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL])
        {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target && connection.success == action)
        {
            [connection cancel];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target)
        {
            [connection cancel];
        }
    }
}

- (NSURL *)URLForTarget:(id)target action:(SEL)action
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target && connection.success == action)
        {
            return connection.URL;
        }
    }
    return nil;
}

- (NSURL *)URLForTarget:(id)target
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target)
        {
            return connection.URL;
        }
    }
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation UIImageView(AsyncImageView)

- (void)setImageURL:(NSURL *)imageURL
{
    [[AsyncImageLoader sharedLoader] loadImageWithURL:imageURL target:self action:@selector(setImage:)];
}

- (NSURL *)imageURL
{
    return [[AsyncImageLoader sharedLoader] URLForTarget:self action:@selector(setImage:)];
}

@end


@interface AsyncImageView ()
{
    AsyncImageViewSuccessCallback _successCallback;
    AsyncImageViewErrorCallback _errorCallback;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation AsyncImageView

- (void)setImageURLString:(NSString *)imageURLString success:(AsyncImageViewSuccessCallback)successCallback error:(AsyncImageViewErrorCallback)errorCallback
{
    _successCallback = [successCallback copy];
    _errorCallback = [errorCallback copy];
    
    NSURL* url = [NSURL URLWithString:imageURLString];
    UIImage *image = [[AsyncImageLoader sharedLoader].cache objectForKey:url];
    if (image){
        [self success:image];
        return;
    }
    else{
        self.image = nil;
    }
    if (self.showActivityIndicator && !self.image && url)
    {
        if (self.activityView == nil)
        {
            self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
            self.activityView.hidesWhenStopped = YES;
            self.activityView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:self.activityView];
        }
        [self.activityView startAnimating];
        [[AsyncImageLoader sharedLoader] loadImageWithURL:url target:self success:@selector(success:) failure:@selector(error:url:)];
    }
}

- (void)success:(UIImage*)aImage
{
    [self setImage:aImage];
    if(_successCallback){
        _successCallback(aImage);
    }
}

- (void)error:(NSError*)error url:(NSURL*)url
{
    if([self.activityView isAnimating]){
        [self.activityView stopAnimating];
    }
    
    if(_errorCallback){
        _errorCallback(error, url);
    }
}

- (void)setUp
{
    self.showActivityIndicator = (self.image == nil);
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.crossfadeDuration = 0.4;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
    UIImage *image = [[AsyncImageLoader sharedLoader].cache objectForKey:imageURL];
    if (image)
    {
        self.image = image;
        return;
    }
    super.imageURL = imageURL;
    if (self.showActivityIndicator && !self.image && imageURL)
    {
        if (self.activityView == nil)
        {
            self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
            self.activityView.hidesWhenStopped = YES;
            self.activityView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:self.activityView];
        }
        [self.activityView startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.activityView stopAnimating];
        });
    }
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    _activityIndicatorStyle = style;
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

- (void)setImage:(UIImage *)image
{
    if (image != self.image && self.crossfadeDuration)
    {
        CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
        [animation setValue:@"kCATransitionFade" forKey:@"type"];
        animation.duration = self.crossfadeDuration;
        [self.layer addAnimation:animation forKey:nil];
    }
    super.image = image;
    [self.activityView stopAnimating];
}

- (void)dealloc
{
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:self.imageURL target:self];
}

@end

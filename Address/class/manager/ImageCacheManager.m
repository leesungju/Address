//
//  ImageCacheManager.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ImageCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ImageCacheManager

+ (ImageCacheManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

-(id)init {
    self = [super init];
    
    if (self) {
        // url 캐시 설정
        // 메모리 : 10MB, 디스크 : 50MB
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        
        // 메모리 캐시 설정
        // @todo : 최대 사이즈와 적정 사이즈 조절 기능 필요
        mMemCache = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)saveImage:(UIImage*)image forKey:(NSString*)key
{
    [self saveToMemory:image withKey:key];
}

// url을 사용해서 md5 해시 문자열 생성
-(NSString*)md5:(NSString *)str {
    const char * pointer = str.UTF8String;
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString * string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x", md5Buffer[i]];
    }
    return string;
}

-(UIImage*)loadFromMemory:(NSString *)key {
    if (mMemCache == nil) return nil;
    
    UIImage* cachedImage = [UIImage imageWithData:[mMemCache objectForKey:key]];
    return cachedImage;
}

-(UIImage*)saveToMemory:(UIImage*)image withKey:(NSString*)key {
    if (mMemCache == nil) {
        mMemCache = [NSMutableDictionary new];
    }
    NSData * data =  UIImagePNGRepresentation(image);
    [mMemCache setObject:data forKey:key];
    return image;
}
@end

//
//  PreferenceManager.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "PreferenceManager.h"

@implementation PreferenceManager

+ (PreferenceManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

/**
 프리퍼런스 저장

 @param value 값
 @param key 키
 */
- (void)setPreference:(NSString*)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

/**
 프리퍼런스 불러오기

 @param key 키
 @param value 디폴트 값
 @return 값
 */
- (NSString*)getPreference:(NSString*)key defualtValue:(NSString*)value
{
    NSString * ret = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if(ret == nil){
        ret = value;
    }
    return ret;
}


/**
 프리퍼런스 삭제

 @param key 키
 */
- (void)removePreference:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}


@end

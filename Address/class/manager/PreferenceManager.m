//
//  PreferenceManager.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "PreferenceManager.h"

@interface PreferenceManager ()

@property (strong, nonatomic) NSUserDefaults * userDefaults;

@end

@implementation PreferenceManager

+ (PreferenceManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"group.sj.address"];
    }
    return self;
}

/**
 프리퍼런스 저장

 @param value 값
 @param key 키
 */
- (void)setPreference:(NSString*)value forKey:(NSString*)key
{
    [_userDefaults setObject:value forKey:key];
    [_userDefaults synchronize];
    
    if([key isEqualToString:@"contacts"]){
        [self watchUpdate:@{key:value}];
    }
}

/**
 프리퍼런스 불러오기

 @param key 키
 @param value 디폴트 값
 @return 값
 */
- (NSString*)getPreference:(NSString*)key defualtValue:(NSString*)value
{
    NSString * ret = [_userDefaults stringForKey:key];
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
    [_userDefaults removeObjectForKey:key];
}

- (void)watchUpdate:(NSDictionary*)dict
{
    [[WCSession defaultSession] transferUserInfo:dict];
//    [[WCSession defaultSession] updateApplicationContext:dict error:nil];
}

- (void)sendWatchMessage:(NSDictionary*)dict
{
    [[WCSession defaultSession] sendMessage:dict replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];
}

@end

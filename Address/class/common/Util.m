//
//  Util.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)deviceUUIDWithSeparator:(BOOL)isSeparator
{
    NSString* ret = nil;
    
    if([[NSUserDefaults standardUserDefaults] stringForKey: @"deviceuuid"] == NULL){
        NSString *strUUID = nil;
        float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(iosVersion < 6.0){
            CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        }
        else{
            strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey: @"deviceuuid"];
    }
    
    ret = [[NSUserDefaults standardUserDefaults] stringForKey: @"deviceuuid"];
    if(!isSeparator){
        ret = [ret stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return ret;
}

+ (NSString *)deviceUUID
{
    return [Util deviceUUIDWithSeparator:NO];
}

+ (BOOL)isMyDeviceUUID:(NSString*)uuid
{
    return [[self deviceUUID] isEqualToString:uuid];
}

@end

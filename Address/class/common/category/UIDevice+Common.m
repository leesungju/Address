//
//  UIDevice+Common.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "UIDevice+Common.h"
#import "KeychainItemWrapper.h"

@implementation UIDevice (SJCommon)


+ (NSString*)getDeviceId
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
    NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    if( uuid == nil || uuid.length == 0)
    {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
    }
    
    return uuid;
}

+ (NSString*)getName
{
    return [[PreferenceManager sharedInstance] getPreference:@"name" defualtValue:@""];
}

+ (NSString*)getPhoneNumber
{
    return [[PreferenceManager sharedInstance] getPreference:@"phone" defualtValue:@""];
}

@end

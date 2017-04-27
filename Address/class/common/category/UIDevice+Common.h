//
//  UIDevice+Common.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SJCommon)

+ (NSString*)getDeviceId;
+ (NSString*)getName;
+ (NSString*)getPhoneNumber;
+ (NSString*)getPushToken;
@end

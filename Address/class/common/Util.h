//
//  Util.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)deviceUUIDWithSeparator:(BOOL)isSeparator;
+ (NSString *)deviceUUID;
+ (BOOL)isMyDeviceUUID:(NSString*)uuid;

@end

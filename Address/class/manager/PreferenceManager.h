//
//  PreferenceManager.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceManager : NSObject

+ (PreferenceManager *)sharedInstance;

- (void)setPreference:(NSString*)value forKey:(NSString*)key;
- (NSString*)getPreference:(NSString*)key defualtValue:(NSString*)value;
- (void)removePreference:(NSString*)key;

- (void)watchUpdate:(NSDictionary*)dict;
- (void)sendWatchMessage:(NSDictionary*)dict;
@end

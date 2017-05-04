//
//  FCMManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface FCMManager : NSObject

+ (FCMManager*)sharedInstance;

- (void)initialize;
- (void)registerToken:(NSString*)token;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)connectToFcm;
- (void)disconnectFromFcm;

- (void)addGroup:(NSString*)groupId;
- (void)deleteGroup:(NSString*)groupId;
- (void)setLogin;
@end

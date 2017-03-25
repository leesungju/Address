//
//  FCMManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "FCMManager.h"

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@interface FCMManager () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property (nonatomic, strong) NSString * pushToken;
@property (nonatomic, assign) BOOL isBizappReady;
@end

@implementation FCMManager


+ (FCMManager *)sharedInstance {
    static FCMManager* sharedInstance = nil;
    if(sharedInstance == nil) {
        @synchronized(self) {
            if(sharedInstance == nil) {
                sharedInstance = [[FCMManager alloc] init];
            }
        }
    }
    return sharedInstance;
}

- (void)initialize {
    UIApplication* application = [UIApplication sharedApplication];
    // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIRemoteNotificationType allNotificationTypes =
            (UIRemoteNotificationTypeSound |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeBadge);
            [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
        } else {
            // iOS 8 or later
            // [START register_for_notifications]
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
                UIUserNotificationType allNotificationTypes =
                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
                UIUserNotificationSettings *settings =
                [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
                [application registerUserNotificationSettings:settings];
            } else {
                // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                UNAuthorizationOptions authOptions =
                UNAuthorizationOptionAlert
                | UNAuthorizationOptionSound
                | UNAuthorizationOptionBadge;
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
                }];
                
                // For iOS 10 display notification (sent via APNS)
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
                // For iOS 10 data message (sent via FCM)
                [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
            }
            
            [application registerForRemoteNotifications];
            // [END register_for_notifications]
        }
    
    // [START configure_firebase]
    // [END configure_firebase]
    // [START add_token_refresh_observer]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    // [END add_token_refresh_observer]
}

- (void)registerToken:(NSString *)token {
    NSLog(@"%s, %@", __FUNCTION__, token);
    // TODO : FCM에서 전달 된 푸시 토큰 서버로 등록
    _pushToken = token;
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%s, %@", __FUNCTION__, userInfo);
    
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // TODO : 푸시 메시지 처리
}

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", remoteMessage.appData);
}
#endif
// [END ios_10_data_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    [self registerToken:refreshedToken];
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    [self disconnectFromFcm];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            //topic 등록 후 사용
            [[FIRMessaging messaging] subscribeToTopic:@"/topics/notice_butler"];
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

// [START disconnectFromFcm]
- (void)disconnectFromFcm {
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
}
// [END disconnectFromFcm]

@end

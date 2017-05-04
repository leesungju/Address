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
@property (nonatomic, assign) BOOL isLogin;
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

- (void)addGroup:(NSString*)groupId
{
    NSString * group = [NSString stringWithFormat:@"/topics/%@",groupId];
    [[FIRMessaging messaging] subscribeToTopic:group];
}

- (void)deleteGroup:(NSString*)groupId
{
    NSString * group = [NSString stringWithFormat:@"/topics/%@",groupId];
    [[FIRMessaging messaging] unsubscribeFromTopic:group];
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
    [[PreferenceManager sharedInstance] setPreference:_pushToken forKey:@"pushToken"];
    if(_isLogin){
        MemberObj * obj = [MemberObj new];
        [obj setName:[UIDevice getName]];
        [obj setPhoneNumber:[UIDevice getPhoneNumber]];
        [obj setMemberId:[UIDevice getDeviceId]];
        [obj setImagePath:[UIDevice getImagePath]];
        [obj setCreateDate:[Util fullDateConvertString:[NSDate new]]];
        [obj setPushToken:_pushToken];
        [[StorageManager sharedInstance] saveUser:[obj getDict] forKey:[UIDevice getDeviceId]];
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%s, %@", __FUNCTION__, userInfo);
    
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    NSDictionary * aps = [userInfo objectForKey:@"aps"];
    NSDictionary * alert = [aps objectForKey:@"alert"];
    NSString *body = [alert objectForKey:@"body"];
    // TODO : 푸시 메시지 처리
    [[GUIManager sharedInstance] showAlert:body viewCon:[[[GUIManager sharedInstance] mainNavigationController].viewControllers lastObject] handler:^(UIAlertAction *action) {
        
    }];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {

    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    
    [self connectToFcm];
    
    [self registerToken:refreshedToken];
}

- (void)connectToFcm {
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    [self disconnectFromFcm];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)disconnectFromFcm {
    [[FIRMessaging messaging] disconnect];
}

- (void)setLogin
{
    _isLogin = YES;
    if([[UIDevice getPushToken] length] > 0){
        MemberObj * obj = [MemberObj new];
        [obj setName:[UIDevice getName]];
        [obj setPhoneNumber:[UIDevice getPhoneNumber]];
        [obj setMemberId:[UIDevice getDeviceId]];
        [obj setImagePath:[UIDevice getImagePath]];
        [obj setCreateDate:[Util fullDateConvertString:[NSDate new]]];
        [obj setPushToken:[UIDevice getPushToken]];
        [[StorageManager sharedInstance] saveUser:[obj getDict] forKey:[UIDevice getDeviceId]];
    }
}
@end

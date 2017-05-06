//
//  AppDelegate.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<WCSessionDelegate>{
    WCSession *session;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    [[FCMManager sharedInstance] initialize];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window setRootViewController:[[GUIManager sharedInstance] mainNavigationController]];
    
    if ([WCSession isSupported]) {
        [WCSession defaultSession].delegate = self;
        session = [WCSession defaultSession];
        session.delegate = self;
        NSLog(@"Sessiopn on phone starting");
        [[WCSession defaultSession] activateSession];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FCMManager sharedInstance] disconnectFromFcm];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[FCMManager sharedInstance] connectToFcm];
    NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
    NSArray * array = [Util stringConvertArray:contacts];
    if([contacts length] > 0){
        [[PreferenceManager sharedInstance] sendWatchMessage:[NSDictionary dictionaryWithObjectsAndKeys:array,@"contacts", nil]];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[FCMManager sharedInstance] didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[FCMManager sharedInstance] didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]


#pragma mark - Watch kit
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    
    if(message){
        if([message objectForKey:@"tell"]){
            NSString * tel = [NSString stringWithFormat:@"tel:%@", [message objectForKey:@"tell"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:nil];
        }
    }
    // In this case, the message content being sent from the app is a simple begin message. This tells the app to wake up and begin sending location information to the watch.
    NSLog(@"Reached IOS APP");
}
-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    NSLog(@"Reached IOS APP");
}

-(void)sessionDidBecomeInactive:(WCSession *)session
{
    
}
@end

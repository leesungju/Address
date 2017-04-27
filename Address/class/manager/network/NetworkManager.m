//
//  NetworkManager.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"

@interface NetworkManager () <NSURLSessionDelegate>

@end

@implementation NetworkManager

+ (NetworkManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (void)sendRequest:(NSMutableURLRequest*)request completionHandler:(void (^)(NSDictionary* ret))completionHandler;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error:%@",error.description);
        }
        if (data) {
            NSString* contentType = [[(NSHTTPURLResponse*)response allHeaderFields] valueForKey:@"content-type"];
            if([contentType containsString:@"application/json"]){
                NSString *newStr = [[NSString stringWithUTF8String:[data bytes]] stringByReplacingOccurrencesOfString:@";" withString:@""];
                NSDictionary *json_response = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:NULL];
                //                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                completionHandler(json_response);
            }else{

            }
        }
    }];
    
    [postDataTask resume];
    
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host isEqualToString:@"fcm.googleapis.com"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}


- (BOOL)checkInternet
{
    Reachability * curReach = [Reachability reachabilityForInternetConnection];
    [curReach startNotifier];
    BOOL connectNetwork = NO;
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    NSString *statusString = @"";
    switch (netStatus)
    {
        case NotReachable:
            statusString = @"Access Not Available";
            connectNetwork = NO;
            break;
        case ReachableViaWiFi:
            statusString = @"Reachable WiFi";
            connectNetwork = YES;
            break;
        case ReachableViaWWAN:
            statusString = @"Reachable WWAN";
            connectNetwork = YES;
            break;
            
        default:
            break;
    }
    return connectNetwork;
}


@end

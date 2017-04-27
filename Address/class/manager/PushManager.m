//
//  PushManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 27..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "PushManager.h"
#import "Requester.h"

@implementation PushManager

+ (PushManager*)sharedInstance
{
    static PushManager* sharedInstance = nil;
    if(sharedInstance == nil) {
        @synchronized(self) {
            if(sharedInstance == nil) {
                sharedInstance = [[PushManager alloc] init];
            }
        }
    }
    return sharedInstance;
}


- (void)sendServer:(NSDictionary*)message
{
//    URL url = new URL(FMCurl);
//    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//    
//    conn.setUseCaches(false);
//    conn.setDoInput(true);
//    conn.setDoOutput(true);
//    
//    conn.setRequestMethod("POST");
//    conn.setRequestProperty("Authorization", "key=" + authKey);
//    conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
//    
//    OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
//    wr.write(json.toString());
//    wr.flush();
//    conn.getInputStream();
    
    Requester * req = [[Requester alloc] initWithUrl:FCM_URL connectionType:kConnectionType_POST];
    [req setContentType:@"application/json"];
    [req setHeader:[NSDictionary dictionaryWithObjectsAndKeys:FCM_AUTH_KEY,@"Authorization", nil]];
    [req setBodyWithDict:message];
    [req sendRequest:^(NSDictionary *ret) {
        NSLog(@"%@",ret);
    }];
    
}

- (void)makePushMessage:(NSString*)groupId message:(NSString*)msg
{
    NSMutableDictionary * message = [NSMutableDictionary new];
    NSMutableDictionary * info = [NSMutableDictionary new];
    NSMutableDictionary * data = [NSMutableDictionary new];
    
   NSString * group = [NSString stringWithFormat:@"/topics/%@",groupId];
    [message setObject:group forKey:@"to"];
    
    [info setObject:@"알림" forKey:@"title"];
    [info setObject:msg forKey:@"body"];
    
    [data setObject:groupId forKey:@"groupId"];
    
    [message setObject:info forKey:@"notification"];
    [message setObject:data forKey:@"data"];

    [self sendServer:message];
}

@end

//
//  NetworkManager.h
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;
- (void)sendRequest:(NSMutableURLRequest*)request completionHandler:(void (^)(NSDictionary* ret))completionHandler;
- (BOOL)checkInternet;
@end

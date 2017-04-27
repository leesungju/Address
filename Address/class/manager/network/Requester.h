//
//  Requester.h
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kConnectionType_GET,
    kConnectionType_POST,
    kConnectionType_PUT,
    kConnectionType_DELETE
} kConnectionType;

@interface Requester : NSObject

- (instancetype)initWithUrl:(NSString*)url connectionType:(kConnectionType)connectionType;

- (void)setContentType:(NSString *)contentType;
- (void)setNetworkTimeout:(NSInteger)_timeout;
- (void)setHeader:(NSDictionary*)header;
- (void)setBodyWithDict:(NSDictionary*)body;
- (void)setBodyWithString:(NSString*)str;
- (void)sendRequest:(void (^)(NSDictionary* ret))completionHandler;

@end

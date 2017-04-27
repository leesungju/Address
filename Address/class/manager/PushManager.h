//
//  PushManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 27..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject
+ (PushManager*)sharedInstance;
- (void)makePushMessage:(NSString*)groupId message:(NSString*)msg;
@end

//
//  StorageManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageManager : NSObject

+ (StorageManager *)sharedInstance;

- (void)saveUser:(NSString*)josnString forKey:(NSString*)key;
- (void)loadUserKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlock;

- (void)savePermissionforKey:(NSString*)key;
- (void)loadPermissionforKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlock;

@end

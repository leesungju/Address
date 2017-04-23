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

- (void)saveUser:(id)obj forKey:(NSString*)key;
- (void)loadUserKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;

- (void)saveGroup:(id)obj forKey:(NSString*)key;
- (void)loadGroupWithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;
- (void)removeGroupKey:(NSString*)key;

- (void)joinGroup:(id)obj forKey:(NSString*)key;
- (void)loadMember:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;
- (void)removeMemberWithGroup:(NSString*)group forKey:(NSString*)key;

@end

//
//  StorageManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageManager : NSObject

typedef void(^UploadCompletionBlock)(NSMutableArray* array);
typedef void(^DownCompletionBlock)(UIImage* image);

+ (StorageManager *)sharedInstance;

- (void)saveUser:(id)obj forKey:(NSString*)key;
- (void)loadUserKey:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;

- (void)savebackupContacts:(id)obj forKey:(NSString*)key;
- (void)loadBackupContacts:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;

- (void)saveGroup:(id)obj forKey:(NSString*)key;
- (void)loadGroupWithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;
- (void)removeGroupKey:(NSString*)key;

- (void)joinGroup:(id)obj forKey:(NSString*)key;
- (void)loadMember:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;
- (void)removeMemberWithGroup:(NSString*)group forKey:(NSString*)key;

- (void)saveContents:(id)obj forKey:(NSString*)key;
- (void)loadContents:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock;
- (void)removeContents:(NSString*)group forKey:(NSString*)key;

- (void)fileUpload:(NSMutableArray*)array forKey:(NSString*)key completion:(UploadCompletionBlock)completion;
- (void)downFile:(NSString*)path completion:(DownCompletionBlock)completion;
- (void)removeFile:(NSString*)path completion:(DownCompletionBlock)completion;
@end

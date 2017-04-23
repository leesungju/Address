//
//  StorageManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "StorageManager.h"
@interface StorageManager ()
@property (strong, nonatomic) FIRDatabaseReference * ref;
@end

@implementation StorageManager

+ (StorageManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ref = [[FIRDatabase database] reference];
    }
    return self;
}

- (void)saveUser:(id)obj forKey:(NSString*)key
{
    [[[_ref child:@"users"] child:key] setValue:obj];
}

- (void)loadUserKey:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
{
    [[[_ref child:@"users"] child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)saveGroup:(id)obj forKey:(NSString*)key
{
    [[[_ref child:@"groups"] child:key] setValue:obj];
}

- (void)loadGroupWithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
{
    [[_ref child:@"groups"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)removeGroupKey:(NSString*)key
{
    [[[_ref child:@"groups"] child:key] removeValue];
}

- (void)joinGroup:(id)obj forKey:(NSString*)key
{
    [_ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        
        NSMutableDictionary *member = [[[post objectForKey:@"groups"] objectForKey:key] objectForKey:@"member"];
        if (!member) {
            member = [NSMutableDictionary new];
        }
        [member setValue:obj forKey:[obj objectForKey:@"memberId"]];
        int memberCount = (int)[member count];
        post[@"groups"][key][@"memberCount"] = [NSNumber numberWithInt:memberCount];
        post[@"groups"][key][@"member"] = member;
        [currentData setValue:post];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)loadMember:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
{
    [[[[_ref child:@"groups"] child:key] child:@"member"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)removeMemberWithGroup:(NSString*)group forKey:(NSString*)key
{
    [[[[[_ref child:@"groups"] child:group] child:@"member"] child:key] removeValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSMutableDictionary *post = currentData.value;
            if (!post || [post isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }
            
            NSMutableDictionary *member = [[[post objectForKey:@"groups"] objectForKey:group] objectForKey:@"member"];
            if (!member) {
                member = [NSMutableDictionary new];
            }
            int memberCount = (int)[member count];
            post[@"groups"][group][@"memberCount"] = [NSNumber numberWithInt:memberCount];
            [currentData setValue:post];
            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    });
}

- (void)saveContents:(id)obj forKey:(NSString*)key
{
    [_ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        
        NSMutableDictionary * contents = [[[post objectForKey:@"groups"] objectForKey:key] objectForKey:@"contents"];
        if (!contents) {
            contents = [NSMutableDictionary new];
        }
        [contents  setValue:obj forKey:[obj objectForKey:@"contentsId"]];
        
        int contentsCount = (int)[contents count];
        post[@"groups"][key][@"contentsCount"] = [NSNumber numberWithInt:contentsCount];
        post[@"groups"][key][@"contents"] = contents;
        [currentData setValue:post];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)loadContents:(NSString*)key withBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
{
    [[[[_ref child:@"groups"] child:key] child:@"contents"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)removeContents:(NSString*)group forKey:(NSString*)key
{
    [[[[[_ref child:@"groups"] child:group] child:@"contents"] child:key] removeValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSMutableDictionary *post = currentData.value;
            if (!post || [post isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }
            
            NSMutableDictionary * contents = [[[post objectForKey:@"groups"] objectForKey:group] objectForKey:@"contents"];
            if (!contents) {
                contents = [NSMutableDictionary new];
            }
            
            int contentsCount = (int)[contents count];
            post[@"groups"][group][@"contentsCount"] = [NSNumber numberWithInt:contentsCount];
            [currentData setValue:post];
            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    });

}

@end

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

- (void)loadUserKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
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

- (void)loadMember:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(void (^)(NSError* error))cancelBlock
{
    [[[[_ref child:@"groups"] child:key] child:@"member"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)removeMemberWithGroup:(NSString*)group forKey:(NSString*)key
{
    [[[[[_ref child:@"groups"] child:group] child:@"member"] child:key] removeValue];
}


@end

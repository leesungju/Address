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

- (void)saveUser:(NSString*)josnString forKey:(NSString*)key
{
    [[[_ref child:@"users"] child:key] setValue:josnString];
}

- (void)loadUserKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlock
{
    [[[_ref child:@"users"] child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}

- (void)loadPermissionforKey:(NSString*)key WithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlock
{
    [[[_ref child:@"permission"] child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}



@end

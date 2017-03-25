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

- (void)save
{
    [[[_ref child:@"users"] child:@"address-123"] setValue:@{@"username": @"qwe"}];
}

- (void)load
{
    
    [[[_ref child:@"users"] child:@"address-123"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        NSLog(@"%@",snapshot.value[@"username"]);
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end

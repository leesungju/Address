//
//  DropBoxManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 24..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "DropBoxManager.h"

@implementation DropBoxManager

+ (DropBoxManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

@end

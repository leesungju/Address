//
//  MemberObj.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "JsonObject.h"

@interface MemberObj : JsonObject

@property (strong, nonatomic) NSString * memberId;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * phoneNumber;
@property (strong, nonatomic) NSNumber * permission;

@end

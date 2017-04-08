//
//  AddressObj.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObj : JsonObject

@property(strong, nonatomic) NSString * section;
@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * phoneNumber;
@property(strong, nonatomic) NSString * group;
@property(strong, nonatomic) NSString * birthDay;
@property(strong, nonatomic) NSString * email;
@property(strong, nonatomic) NSString * address;
@property(strong, nonatomic) NSString * imageData;
@property(strong, nonatomic) NSString * family;
@property(strong, nonatomic) NSArray * memoArray;
@property(strong, nonatomic) NSString *wordIndex;

-(void)setdata;
-(NSString*)getWordIndex;

@end

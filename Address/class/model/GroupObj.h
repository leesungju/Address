//
//  GroupObj.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupObj : JsonObject

@property (strong, nonatomic) NSString * groupId;
@property (strong, nonatomic) NSString * groupContents;
@property (strong, nonatomic) NSArray * contents;
@property (strong, nonatomic) NSNumber * contentsCount;
@property (strong, nonatomic) NSDictionary * member;
@property (strong, nonatomic) NSNumber * memberCount;
@property (strong, nonatomic) NSString * createDt;
@property (strong, nonatomic) NSNumber * publicType;
@property (strong, nonatomic) NSString * pwd;
@property(strong, nonatomic) NSString *wordIndex;

-(void)setdata;
-(NSString*)getWordIndex;

@end

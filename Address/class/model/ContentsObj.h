//
//  ContentsObj.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "JsonObject.h"

@interface ContentsObj : JsonObject

@property (strong, nonatomic) NSString * contentsId;
@property (strong, nonatomic) NSString * contentsTitle;
@property (strong, nonatomic) NSString * contents;
@property (strong, nonatomic) NSString * filePath;
@property (strong, nonatomic) NSString * createDt;
@property (strong, nonatomic) NSMutableArray * imageArray;

@end

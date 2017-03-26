//
//  JsonObject.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonObject : NSObject

- (NSString*)getJsonString;
- (void)setJsonString:(NSString*)str;
- (NSData*)getJsonData;
- (void)setJsonData:(NSData*)data;
- (NSMutableDictionary*)getDict;
- (void)setDict:(NSDictionary*)dict;

@end

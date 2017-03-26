//
//  JsonObject.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "JsonObject.h"
#import <objc/runtime.h>

@implementation JsonObject

- (BOOL)isObjectWithName:(NSString*)str
{
    BOOL isExist = NO;
    NSString * name = @"";
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    if(ivars)
    {
        for(uint32_t i=0; i<ivarCount; i++)
        {
            Ivar ivar = ivars[i];
            name = [NSString stringWithUTF8String:ivar_getName(ivar)];
            NSRange aRange = [name rangeOfString:str];
            if (aRange.location != NSNotFound)
            {
                isExist = YES;;
                break;
            }
        }
        
        free(ivars);
    }
    
    return isExist;
}

- (NSString*)getJsonString
{
    return [[NSString alloc] initWithData:[self getJsonData] encoding:NSUTF8StringEncoding];
}

- (void)setJsonString:(NSString*)str
{
    NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self setJsonData:objectData];
}

- (NSData*)getJsonData
{
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self getDict] options:0 error:&jsonError];
    
    return jsonData;
}


- (void)setJsonData:(NSData*)data
{
    id json_response = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:NULL];
    if([json_response isKindOfClass:[NSDictionary class]]){
        [self setDict:json_response];
    }
}

- (NSMutableDictionary*)getDict
{
    NSMutableDictionary *muteDictionary = [NSMutableDictionary dictionary];
    unsigned int ivarCount;
    objc_property_t *properties = class_copyPropertyList([self class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        SEL propertySelector = NSSelectorFromString(propertyName);
        if ([self respondsToSelector:propertySelector]) {
            [muteDictionary setValue:[self performSelector:propertySelector] forKey:propertyName];
        }
    }
    
    return muteDictionary;
}

- (void)setDict:(NSDictionary*)dict
{
    for(NSString * key in [dict allKeys]){
        if([self isObjectWithName:key]){
            [self setValue:[dict objectForKey:key] forKey:key];
        }
    }
}




@end

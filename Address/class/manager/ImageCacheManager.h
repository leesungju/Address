//
//  ImageCacheManager.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject
{
    NSMutableDictionary* mMemCache;
}

+ (ImageCacheManager*)sharedInstance;

- (void)saveImage:(UIImage*)image forKey:(NSString*)name;

-(NSString*)md5:(NSString *)str;

-(UIImage*)saveToMemory:(UIImage*)image withKey:(NSString*)key;
-(UIImage*)loadFromMemory:(NSString*)key;

@end

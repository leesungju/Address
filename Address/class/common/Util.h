//
//  Util.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString*)arrayConvertJsonString:(NSArray*)array;
+ (NSArray*)stringConvertArray:(NSString*)str;
+ (NSString*)saveImage:(UIImage*)image;
+ (NSString*)dateConvertString:(NSDate*)date;
+ (NSString*)timeStamp;
@end

//
//  NSStrUtils.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved
//

#import <Foundation/Foundation.h>

@interface NSStrUtils : NSObject

+(NSString*)getJasoLetter:(NSString*)target;
+(BOOL)isKorean:(unichar) target; 

@end
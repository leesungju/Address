//
//  Util.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString*)arrayConvertJsonString:(NSArray*)array
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSArray*)stringConvertArray:(NSString*)str
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+ (NSString*)saveImage:(UIImage*)image
{
    //obtaining saving path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name = [NSString stringWithFormat:@"%d.png",(int)[[NSDate date] timeIntervalSince1970]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:name];
    NSData *webData = UIImagePNGRepresentation(image);
    [webData writeToFile:imagePath atomically:YES];
    return imagePath;
}

+ (NSString*)dateConvertString:(NSDate*)date
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy년 MM월 dd일"];
    return [format stringFromDate:date];
}

+ (NSString*)timeStamp
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}
@end

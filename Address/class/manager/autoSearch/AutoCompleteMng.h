//
//  AutoCompleteMng.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoCompleteMng : NSObject
{
    NSMutableArray *acdArr; //AutoCompleteData Array.
}

-(id)initWithData:(NSMutableArray*)data;
-(NSArray*)search:(NSString*)keyword;

@end

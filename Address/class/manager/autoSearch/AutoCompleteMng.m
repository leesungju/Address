//
//  AutoCompleteMng.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "AutoCompleteMng.h"

@implementation AutoCompleteMng

-(id)initWithData:(NSMutableArray*)data
{
    self = [super init];
    if (self)
    {
        acdArr = [[NSMutableArray alloc]init];
        int count = (int)[data count];
        
        for(int i =0; i<count; i++)
        {
            AddressObj * temp = [data objectAtIndex:i];
            [temp setdata];
            [acdArr addObject:temp];
        }
    }
    return self;
}

-(NSArray*)search:(NSString*)keyword
{    
    NSString * keywordLetter = [NSStrUtils getJasoLetter:keyword];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wordIndex CONTAINS[c] %@", keywordLetter];
    
    return [acdArr filteredArrayUsingPredicate:predicate];
    
}



@end

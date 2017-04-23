//
//  GroupObj.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 22..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupObj.h"

@implementation GroupObj

- (void)setdata
{
    _wordIndex = [NSStrUtils getJasoLetter:_groupContents];
}

- (NSString*)getWordIndex
{
    return _wordIndex;
}

@end

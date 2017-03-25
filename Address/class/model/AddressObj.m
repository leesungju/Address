//
//  AddressObj.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "AddressObj.h"

@implementation AddressObj


-(void)setdata
{
    _wordIndex = [NSStrUtils getJasoLetter:_name];
}
-(NSString*)getWordIndex
{
    return _wordIndex;
}


@end

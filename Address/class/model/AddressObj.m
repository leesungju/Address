//
//  AddressObj.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "AddressObj.h"

@implementation AddressObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memoArray = [NSMutableArray new];
    }
    return self;
}

- (void)setdata
{
    _wordIndex = [NSStrUtils getJasoLetter:_name];
}

- (NSString*)getWordIndex
{
    return _wordIndex;
}

- (UIImage*)image
{
    if(_imagePath.length > 0){
        _image = [[UIImage alloc] initWithContentsOfFile:_imagePath];
    }
    return _image;
}


@end

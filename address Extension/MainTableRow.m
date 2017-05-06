//
//  MainTableRow.m
//  Address
//
//  Created by LeeSungJu on 2017. 5. 6..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//


#import "MainTableRow.h"

@implementation MainTableRow

- (IBAction)callAction {
    if([_delegate respondsToSelector:@selector(callBtnAction:)]){
        [_delegate callBtnAction:@{@"tell":_phoneNumber}];
    }
}

@end

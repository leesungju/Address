//
//  MemoPopupViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 9..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    kViewPopupMode_nomarl,
    kViewPopupMode_add,
    kViewPopupMode_edit
} kViewPopupMode;

@interface MemoPopupViewController : UIViewController
@property (assign, nonatomic) kViewPopupMode viewMode;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) int index;

@end

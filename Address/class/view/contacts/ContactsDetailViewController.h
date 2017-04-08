//
//  ContactsDetailViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 8..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    kViewMode_nomarl,
    kViewMode_add,
    kViewMode_edit
} kViewMode;

@interface ContactsDetailViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray * totalDataArray;
@property (assign, nonatomic) int index;
- (void)viewMode:(kViewMode)mode;
@end

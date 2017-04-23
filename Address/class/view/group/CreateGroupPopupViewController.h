//
//  CreateGroupPopupViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    kGroupViewType_nomarl,
    kGroupViewType_add,
    kGroupViewType_edit
} kGroupViewType;

@interface CreateGroupPopupViewController : UIViewController

@property (strong, nonatomic) GroupObj * groupObj;
@property (assign, nonatomic) kGroupViewType type;

@end

//
//  GroupContentsViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kGroupContentsViewType_nomarl,
    kGroupContentsViewType_add,
    kGroupContentsViewType_edit
} kGroupContentsViewType;


@interface GroupContentsViewController : UIViewController

@property (strong, nonatomic) GroupObj * group;
@property (strong, nonatomic) ContentsObj * contentsObj;
@property (assign, nonatomic) kGroupContentsViewType type;

@end

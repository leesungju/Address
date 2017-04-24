//
//  SyncPopupViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 14..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kViewType_Snyc,
    kViewType_sms,
    kViewType_groupSms
} kViewType;

@interface SyncPopupViewController : UIViewController

@property (assign, nonatomic) kViewType type;
@property (strong, nonatomic) NSDictionary * dataDict;

@end

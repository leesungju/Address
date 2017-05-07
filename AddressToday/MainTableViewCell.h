//
//  MainTableViewCell.h
//  Address
//
//  Created by LeeSungJu on 2017. 5. 7..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *smsBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneBtn;
@property (strong, nonatomic) NSString * phoneNumber;
@property (strong, nonatomic) NSExtensionContext * context;

@end

//
//  ContactsTableViewCell.h
//  Aireleven
//
//  Created by SungJu on 2017. 3. 20..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *smsBtn;
@property (strong, nonatomic) IBOutlet UIButton *tellBtn;


@end

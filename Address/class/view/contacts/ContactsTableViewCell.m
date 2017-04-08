//
//  ContactsTableViewCell.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 20..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "ContactsTableViewCell.h"
@interface ContactsTableViewCell()


@end
@implementation ContactsTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)smsBtnAction:(id)sender {
    NSString * sms = [NSString stringWithFormat:@"sms:%@", _phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sms] options:@{} completionHandler:nil];

}

- (IBAction)tellBtnAction:(id)sender {
    NSString * tel = [NSString stringWithFormat:@"tel:%@", _phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:nil];
}
@end

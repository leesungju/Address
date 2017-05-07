//
//  MainTableViewCell.m
//  Address
//
//  Created by LeeSungJu on 2017. 5. 7..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)smsAction:(id)sender {
    NSString * sms = [NSString stringWithFormat:@"sms:%@", _phoneNumber];
     [_context openURL:[NSURL URLWithString:sms] completionHandler:nil];
}
- (IBAction)tellAction:(id)sender {
    NSString * tel = [NSString stringWithFormat:@"tel:%@", _phoneNumber];
    [_context openURL:[NSURL URLWithString:tel] completionHandler:nil];
}

@end

//
//  GroupTableViewCell.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectJoinBtn:)])
        [self.delegate selectJoinBtn:_group];
}

@end

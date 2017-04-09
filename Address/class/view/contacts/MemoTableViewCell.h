//
//  MemoTableViewCell.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 9..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

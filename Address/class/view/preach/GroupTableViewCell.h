//
//  GroupTableViewCell.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupTableViewCellDelegate <NSObject>
- (void)selectJoinBtn:(GroupObj*)group;
@end

@interface GroupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *starImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) IBOutlet UIImageView *countImageView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) GroupObj * group;

@property (nonatomic, retain) id<GroupTableViewCellDelegate> delegate;

@end

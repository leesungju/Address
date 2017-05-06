//
//  MainTableRow.h
//  Address
//
//  Created by LeeSungJu on 2017. 5. 6..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@protocol MainTableRowDelegate <NSObject>
- (void)callBtnAction:(NSDictionary*)dict;
@end

@interface MainTableRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *nameLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *smsBtn;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *callBtn;
@property (strong, nonatomic) NSString * phoneNumber;

@property (nonatomic, retain) id<MainTableRowDelegate> delegate;
@end

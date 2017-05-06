//
//  DetailInterfaceController.m
//  Address
//
//  Created by LeeSungJu on 2017. 5. 6..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "DetailInterfaceController.h"

@interface DetailInterfaceController ()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *nameLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *phoneLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *birthDayLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *groupLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *emailLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *addressLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *familyLabel;
@property (strong, nonatomic) NSDictionary * data;

@end

@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _data = context;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [_nameLabel setText:[_data objectForKey:@"name"]];
    [_phoneLabel setText:[_data objectForKey:@"phoneNumber"]];
    [_birthDayLabel setText:[_data objectForKey:@"birthDay"]];
    [_groupLabel setText:[_data objectForKey:@"group"]];
    [_emailLabel setText:[_data objectForKey:@"email"]];
    [_addressLabel setText:[_data objectForKey:@"address"]];
    [_familyLabel setText:[_data objectForKey:@"family"]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)memoAction {
    NSArray * array = [_data objectForKey:@"memoArray"];
    if(array && [array count] > 0){
        [self pushControllerWithName:@"MemoInterface" context:array];
    }else{
        WKAlertAction * action =  [WKAlertAction actionWithTitle: @"OK"
                                                           style: WKAlertActionStyleDefault
                                                         handler: ^{
                                                             
                                                         }];
        [self presentAlertControllerWithTitle:@"알림" message:@"등록된 메모가 없습니다." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
    }
}

@end




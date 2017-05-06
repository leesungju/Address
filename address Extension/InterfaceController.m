//
//  InterfaceController.m
//  address Extension
//
//  Created by LeeSungJu on 2017. 5. 5..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "InterfaceController.h"
#import "MainTableRow.h"
#import "DetailInterfaceController.h"

@interface InterfaceController () <MainTableRowDelegate>
@property (strong, nonatomic) IBOutlet WKInterfaceTable *mainTable;
@property (strong, nonatomic) NSArray * contactsArray;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedNSNotification) name:@"updateData" object:nil];

    [self dataReload];
}

- (void)dataReload
{
    NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                     initWithSuiteName:@"group.sj.address"];
    NSString* contacts = [userDefaults objectForKey:@"contacts"];
    NSLog(@"%@",contacts);
    if ([contacts length]>0) {
        _contactsArray = [self stringConvertArray:contacts];
        [_mainTable setNumberOfRows:[_contactsArray count] withRowType:@"MainTableRow"];
        for (int i = 0; i < [_contactsArray count] ; i++) {
            MainTableRow * mainRow = [_mainTable rowControllerAtIndex:i];
            [mainRow setDelegate:self];
            NSDictionary * data = [_contactsArray objectAtIndex:i];
            [mainRow.nameLabel setText:[data objectForKey:@"name"]];
            [mainRow setPhoneNumber:[data objectForKey:@"phoneNumber"]];
        }
    }else{
        WKAlertAction * action =  [WKAlertAction actionWithTitle: @"OK"
                                                           style: WKAlertActionStyleDefault
                                                         handler: ^{
                                                             
                                                         }];
        [self presentAlertControllerWithTitle:@"알림" message:@"데이터가 없습니다. 동기화를 해주세요!" preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
    }

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateData" object:nil];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self presentControllerWithName:@"DetailInterface" context:[_contactsArray objectAtIndex:rowIndex]];
}

-(void)callBtnAction:(NSDictionary *)dict
{
    [[WCSession defaultSession] sendMessage:dict replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];
}

- (NSArray*)stringConvertArray:(NSString*)str
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (void)didReceivedNSNotification
{
    [self dataReload];
}

@end




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

@interface InterfaceController () <MainTableRowDelegate, WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfaceTable *mainTable;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *noDataGroup;
@property (strong, nonatomic) NSArray * contactsArray;
@property (strong, nonatomic) NSMutableArray * favArray;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.isReachable) {
            NSLog(@"Able to reach app.");
        }
    }

    [self dataReload];
}

- (void)dataReload
{
    _favArray = [NSMutableArray new];
    NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                     initWithSuiteName:@"group.sj.address"];
    id contacts = [userDefaults objectForKey:@"contacts"];
    NSLog(@"%@",contacts);
    if (contacts) {
        if([contacts isKindOfClass:[NSString class]]){
            _contactsArray = [self stringConvertArray:contacts];
        }else{
            _contactsArray = contacts;
        }
        
        for(int i =0;i<[_contactsArray count];i++){
            BOOL isFav = [[[_contactsArray objectAtIndex:i] objectForKey:@"isFav"] boolValue];
            if(isFav){
                [_favArray addObject:[_contactsArray objectAtIndex:i]];
                NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                [_favArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
            }
        }
        if([_favArray count] == 0){
            WKAlertAction * action =  [WKAlertAction actionWithTitle: @"OK"
                                                               style: WKAlertActionStyleDefault
                                                             handler: ^{
                                                                 
                                                             }];
            [self presentAlertControllerWithTitle:@"알림" message:@"즐겨찾기 목록이 없습니다." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
        }else{
            [_mainTable setNumberOfRows:[_favArray count] withRowType:@"MainTableRow"];
            for (int i = 0; i < [_favArray count] ; i++) {
                MainTableRow * mainRow = [_mainTable rowControllerAtIndex:i];
                [mainRow setDelegate:self];
                NSDictionary * data = [_favArray objectAtIndex:i];
                [mainRow.nameLabel setText:[data objectForKey:@"name"]];
                [mainRow setPhoneNumber:[data objectForKey:@"phoneNumber"]];
            }
            [_noDataGroup setHidden:YES];
        }
    }else{
        [_noDataGroup setHidden:NO];
        [_mainTable setHidden:YES];
        WKAlertAction * action =  [WKAlertAction actionWithTitle: @"OK"
                                                           style: WKAlertActionStyleDefault
                                                         handler: ^{
                                                             
                                                         }];
        [self presentAlertControllerWithTitle:@"알림" message:@"즐겨찾기 목록이 없습니다." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
    }

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateData" object:nil];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self pushControllerWithName:@"DetailInterface" context:[_favArray objectAtIndex:rowIndex]];
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


#pragma mark - WCSession Delegate Methods
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler
{
    if(message){
        NSString* contacts = [message objectForKey:@"contacts"];
        if(contacts){
            NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                             initWithSuiteName:@"group.sj.address"];
            [userDefaults setObject:contacts forKey:@"contacts"];
            NSLog(@"didReceiveMessage");
            [self didReceivedNSNotification];
        }
        
    }}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    if(applicationContext){
        NSString* contacts = [applicationContext objectForKey:@"contacts"];
        if(contacts){
            NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                             initWithSuiteName:@"group.sj.address"];
            [userDefaults setObject:contacts forKey:@"contacts"];
            NSLog(@"didReceiveApplicationContext");
            [self didReceivedNSNotification];
        }
    }
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo
{
    if(userInfo){
        NSString* contacts = [userInfo objectForKey:@"contacts"];
        if(contacts){
            NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                             initWithSuiteName:@"group.sj.address"];
            [userDefaults setObject:contacts forKey:@"contacts"];
            NSLog(@"didReceiveUserInfo");
            [self didReceivedNSNotification];
        }
    }
}

-(void)sessionWatchStateDidChange:(nonnull WCSession *)session
{
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
    }
}

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
    
}
@end




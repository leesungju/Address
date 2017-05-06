//
//  MemoDetailInterfaceController.m
//  Address
//
//  Created by LeeSungJu on 2017. 5. 6..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MemoDetailInterfaceController.h"

@interface MemoDetailInterfaceController ()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *dateLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *placeLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *contentsLabel;
@property (strong, nonatomic) NSDictionary * dataDcit;
@end

@implementation MemoDetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _dataDcit = context;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [_titleLabel setText:[_dataDcit objectForKey:@"title"]];
    [_dateLabel setText:[_dataDcit objectForKey:@"date"]];
    [_placeLabel setText:[_dataDcit objectForKey:@"location"]];
    [_contentsLabel setText:[_dataDcit objectForKey:@"detail"]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end




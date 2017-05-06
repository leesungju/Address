//
//  MemoInterfaceController.m
//  Address
//
//  Created by LeeSungJu on 2017. 5. 6..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MemoInterfaceController.h"
#import "MemoTableRow.h"

@interface MemoInterfaceController ()
@property (strong, nonatomic) NSArray * memoArray;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *memoTable;


@end

@implementation MemoInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    _memoArray = context;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [_memoTable setNumberOfRows:[_memoArray count] withRowType:@"MemoTableRow"];
    for (int i = 0; i < [_memoArray count] ; i++) {
        MemoTableRow * memoRow = [_memoTable rowControllerAtIndex:i];
        NSDictionary * data = [_memoArray objectAtIndex:i];
        [memoRow.titleLabel setText:[data objectForKey:@"title"]];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self pushControllerWithName:@"MemoDetailInterface" context:[_memoArray objectAtIndex:rowIndex]];
}


@end




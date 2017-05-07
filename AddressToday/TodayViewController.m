//
//  TodayViewController.m
//  AddressToday
//
//  Created by LeeSungJu on 2017. 5. 7..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MainTableViewCell.h"

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray *contactsArray;
@property (strong, nonatomic) NSMutableArray *favArray;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation TodayViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactsArray = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSUserDefaults * userDefaults = [[NSUserDefaults alloc]
                                     initWithSuiteName:@"group.sj.address"];
    id contacts = [userDefaults objectForKey:@"fav_contacts"];
    [_favArray removeAllObjects];
    if (contacts) {
        if([contacts isKindOfClass:[NSString class]]){
            _contactsArray = [self stringConvertArray:contacts];
        }else{
            _contactsArray = contacts;
        }
        
    }else{
       
    }
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView reloadData];
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact){
        // Changed to compact mode
        self.preferredContentSize = maxSize;
        [_bottomView setHidden:YES];
    }
    else{
        // Changed to expanded mode
        self.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 30);
        [_bottomView setHidden:NO];
    }
}

#pragma mark - UITableViewDelegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contactsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"MainTableViewCell";
    MainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.nameLabel setText:[[_contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell setContext:self.extensionContext];
    [cell setPhoneNumber:[[_contactsArray objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"]];
    
    return cell;
}

- (IBAction)addressBookAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"com.sj.Address://address"] completionHandler:^(BOOL success) {
        
    }];
}

- (IBAction)groupAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"com.sj.Address://group"] completionHandler:^(BOOL success) {
        
    }];
}


#pragma mark

- (NSArray*)stringConvertArray:(NSString*)str
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}


@end

//
//  ContactsViewController.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 16..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"

@interface ContactsViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageView;
@property (strong, nonatomic) IBOutlet UITableView *retTableView;
@property (strong, nonatomic) NSMutableDictionary * sections;
@property (strong, nonatomic) NSMutableDictionary * oriSections;
@property (strong, nonatomic) NSArray * sectionArray;
@property (strong, nonatomic) NSArray * oriDataArray;
@property (strong, nonatomic) NSString * searchStr;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout];
    [self initViews];
}

- (void)initViews
{
    [_backBtn setImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 6, 4, 6)];
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchTextField setBackgroundColor:[UIColor clearColor]];
    [_searchTextField setTextColor:[UIColor whiteColor]];
    [_searchTextField showBorder:[UIColor whiteColor] width:1];
    [_searchTextField setRadius:5];
    [_searchTextField setDelegate:self];
    [_retTableView setDelegate:self];
    [_retTableView setDataSource:self];
    [_retTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _oriDataArray = [[ContactManager sharedInstance] getContact];
    [self settingTableView:_oriDataArray];
}

- (void)settingTableView:(NSArray*)data
{
    _sections = [[NSMutableDictionary alloc] init]; ///Global Object
    
    BOOL found;
    NSArray * arrayYourData = data;
    for (CNContact *temp in arrayYourData)
    {
        NSString *c = [temp.familyName substringToIndex:1].uppercaseString;
        found = NO;
        NSMutableArray * tempArray;
        for (NSString * headerText in [_sections allKeys])
        {
            if ([headerText.uppercaseString isEqualToString:c])
            {
                found = YES;
                tempArray = [_sections objectForKey:c];
                [tempArray addObject:temp];
                break;
            }
        }
        if (!found)
        {
            tempArray = [NSMutableArray new];
            [tempArray addObject:temp];
        }
        [_sections setObject:tempArray forKey:c];
    }
    _sectionArray = [self sortDictionary:_sections];
    _oriSections = [NSMutableDictionary new];
    _oriSections = [_sections mutableCopy];
    [_retTableView reloadData];
}

- (NSArray*)sortDictionary:(NSDictionary*)dict
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                  ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedKeys = [dict.allKeys sortedArrayUsingDescriptors:descriptors];
    return sortedKeys;
    
}

#pragma textfield delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(_searchStr.length > 0){
        [self searchText];
        [_searchImageView setHidden:YES];
    }else {
        [self settingTableView:_oriDataArray];
        [_searchImageView setHidden:NO];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _searchStr = @"";
    [self settingTableView:_oriDataArray];
    return YES;
}

#pragma mark tableview delgate, datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sections objectForKey:[_sectionArray objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, _retTableView.width - 40, 30)];
    [header setBackgroundColor:RGB(0, 159, 255)];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 320, 30)];
    [header addSubview:lbl];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[[_sectionArray objectAtIndex:section] uppercaseString]];
    [lbl setFont:[UIFont systemFontOfSize:20]];
    return header;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"selectCityTableViewCell";
    ContactsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    NSArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
    CNContact *temp = [tempArray objectAtIndex:indexPath.row];
    NSString * name = [NSString stringWithFormat:@"%@ %@ %@",temp.familyName, temp.middleName, temp.givenName];
    cell.mainLabel.text = name;
    cell.subLabel.text = [[[temp.phoneNumbers firstObject] value] stringValue];
//    [cell.mainLabel setAttributeTextColor:[UIColor whiteColor] changeText:cell.mainLabel.text];
//    [cell.mainLabel setAttributeTextColor:[UIColor redColor] changeText:_searchStr];
   
    CALayer *separator = [CALayer layer];
    separator.frame = CGRectMake(cell.mainLabel.originX - 20, 54, cell.width, 1);
    if([tempArray count] - 1 != indexPath.row && [tempArray count] > 1){
        separator.contents = (id)[UIImage imageWithColor:[UIColor whiteColor]].CGImage;
    }else{
        separator.contents = (id)[UIImage imageWithColor:RGB(48, 179, 254)].CGImage;
    }
    [cell.layer addSublayer:separator];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
//    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[[NSDictionary alloc] initWithObjectsAndKeys:[tempArray objectAtIndex:indexPath.row],@"result", nil]];
    NSArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
//    [[ContactManager sharedInstance] loadContactView:[tempArray objectAtIndex:indexPath.row]];
    
}

#pragma mark - action medhods
- (void)backAction:(id)gesture
{
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

#pragma mark - search medhods

- (void)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"familyName CONTAINS[c] %@", _searchStr];
    for (NSString * key in [_sections allKeys]){
        NSArray* filteredData = [[_oriSections objectForKey:key] filteredArrayUsingPredicate:predicate];
        [_sections setObject:filteredData forKey:key];
    }
    
    [_retTableView reloadData];
}

@end

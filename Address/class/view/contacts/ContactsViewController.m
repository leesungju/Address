//
//  ContactsViewController.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 16..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "AutoCompleteMng.h"
#import "ContactsDetailViewController.h"

@interface ContactsViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageView;
@property (strong, nonatomic) IBOutlet UITableView *retTableView;
@property (strong, nonatomic) NSMutableDictionary * sections;
@property (strong, nonatomic) NSMutableDictionary * oriSections;
@property (strong, nonatomic) NSMutableArray * sectionArray;
@property (strong, nonatomic) NSMutableArray * oriDataArray;
@property (strong, nonatomic) NSString * searchStr;
@property (assign, nonatomic) BOOL isLoad;

@end

@implementation ContactsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oriDataArray = [NSMutableArray new];
        _isLoad = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_isLoad){
        NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
        NSArray * array = [Util stringConvertArray:contacts];
        [_oriDataArray removeAllObjects];
        [_oriDataArray addObjectsFromArray:array];
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:_oriDataArray];
        [_oriDataArray removeAllObjects];
        [_oriDataArray addObjectsFromArray:[orderedSet array]];
        
        [self settingTableView:_oriDataArray];
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"등록", @"동기화", @"백업", nil] delegate:self];

    [self setViewLayout];
    [self selectTabMenu:0];
    [self initViews];
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)initViews
{
    _isLoad = YES;
    [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchTextField setBackgroundColor:[UIColor clearColor]];
    [_searchTextField setTextColor:[UIColor whiteColor]];
    [_searchTextField showBorder:[UIColor whiteColor] width:1];
    [_searchTextField setRadius:5];
    [_searchTextField setDelegate:self];
    [_retTableView setDelegate:self];
    [_retTableView setDataSource:self];
    [_retTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
    NSArray * array = [Util stringConvertArray:contacts];
    
    [_oriDataArray addObjectsFromArray:array];
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:_oriDataArray];
    [_oriDataArray removeAllObjects];
    [_oriDataArray addObjectsFromArray:[orderedSet array]];
    
    [self settingTableView:_oriDataArray];
}

- (void)menuClicked:(int)index
{
    [super menuClicked:index];
    switch (index) {
        case 0:
            
            break;
        case 1:{
            ContactsDetailViewController * contact = [ContactsDetailViewController new];
            [contact.sectionArray addObjectsFromArray:_sectionArray];
            contact.dataDict = _sections;
            [contact setIndex:0];
            [contact setSection:(int)[_sectionArray count]-1];
            [contact viewMode:kViewMode_add];
            [[GUIManager sharedInstance] moveToController:contact animation:YES];
            break;
        }
        case 2: {
            [_oriDataArray addObjectsFromArray:[[ContactManager sharedInstance] getContact]];
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:_oriDataArray];
            [_oriDataArray removeAllObjects];
            [_oriDataArray addObjectsFromArray:[orderedSet array]];
            NSString * resultString = [Util arrayConvertJsonString:_oriDataArray];
            [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
            break;
        }
        case 3:
            
            break;
        default:
            break;
    }
    [self settingTableView:_oriDataArray];
}

- (void)settingTableView:(NSArray*)data
{
    _sections = [[NSMutableDictionary alloc] init]; ///Global Object
    
    BOOL found;
    NSArray * arrayYourData = data;
    for (NSDictionary * dict in arrayYourData)
    {
        AddressObj * temp = [AddressObj new];
        [temp setDict:dict];
        NSString *c = temp.section;
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
    _sectionArray = [NSMutableArray new];
    _sectionArray = [self sortDictionary:_sections];
    _oriSections = [NSMutableDictionary new];
    _oriSections = [_sections mutableCopy];
    [_retTableView reloadData];
}

- (NSMutableArray*)sortDictionary:(NSDictionary*)dict
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                  ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    return [[NSMutableArray alloc] initWithArray:[dict.allKeys sortedArrayUsingDescriptors:descriptors] copyItems:YES];
    
}

- (void)saveData:(NSDictionary*)dict
{
    NSMutableArray * save = [NSMutableArray new];
    for(NSString * key in [dict allKeys]){
        for (AddressObj *obj in [dict objectForKey:key]) {
            [save addObject:obj.getDict];
        }
    }
    NSString * resultString = [Util arrayConvertJsonString:save];
    [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
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
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, _retTableView.width - 40, 20)];
    [header setBackgroundColor:RGB(250, 215, 134)];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 320, 20)];
    [header addSubview:lbl];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[_sectionArray objectAtIndex:section]];
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
    AddressObj *temp = [tempArray objectAtIndex:indexPath.row];

    
    if(temp.image){
        [cell.profileImageView setImage:temp.image];
    }else{
        [cell.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    }
    [cell.nameLabel setText:temp.name];
    [cell.phoneLabel setText:temp.phoneNumber];
    [cell.birthDayLabel setText:temp.birthDay];
    
//    [cell.mainLabel setAttributeTextColor:[UIColor whiteColor] changeText:cell.mainLabel.text];
//    [cell.mainLabel setAttributeTextColor:[UIColor redColor] changeText:_searchStr];
   
//    CALayer *separator = [CALayer layer];
//    separator.frame = CGRectMake(0, 79, cell.width, 1);
//    if([tempArray count] - 1 != indexPath.row && [tempArray count] > 1){
//        separator.contents = (id)[UIImage imageWithColor:RGBA(255, 255, 255, 0.5)].CGImage;
//    }else{
//        separator.contents = (id)[UIImage imageWithColor:RGB(48, 179, 254)].CGImage;
//    }
//    [cell.layer addSublayer:separator];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
    
    ContactsDetailViewController * contact = [ContactsDetailViewController new];
    [contact.sectionArray addObjectsFromArray:_sectionArray];
    contact.dataDict = _sections;
    [contact setIndex:(int)indexPath.row];
    [contact setSection:(int)indexPath.section];
    
    [[GUIManager sharedInstance] moveToController:contact animation:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
    [tempArray removeObjectAtIndex:indexPath.row];
    if([tempArray count] == 0){
        [_sectionArray removeObjectAtIndex:indexPath.section];
    }
    [tableView reloadData];
    [self saveData:_sections];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - action medhods
- (void)backAction:(id)gesture
{
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [_searchTextField resignFirstResponder];
}

#pragma mark - search medhods

- (void)searchText
{
    
    [_sectionArray removeAllObjects];
    for (NSString * key in [_sections allKeys]){
       AutoCompleteMng * automng = [[AutoCompleteMng alloc] initWithData:[_sections objectForKey:key]];
        NSArray* filteredData = [automng search:_searchStr];
        if([filteredData count] > 0){
            [_sections setObject:filteredData forKey:key];
            [_sectionArray addObject:key];
        }
    }
    
    [_retTableView reloadData];
}


@end

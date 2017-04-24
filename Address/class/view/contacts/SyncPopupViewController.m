//
//  SyncPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 14..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SyncPopupViewController.h"
#import "SyncTableViewCell.h"

@interface SyncPopupViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *allBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView2;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn2;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) NSMutableArray * contactsArray;
@property (strong, nonatomic) NSMutableDictionary * saveDict;

@end

@implementation SyncPopupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _saveDict = [NSMutableDictionary new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initViews];
}

- (void)initViews
{
    if(_type == kViewType_Snyc){
        [_popupView setRadius:10];
        _contactsArray = [NSMutableArray new];
        [_contactsArray addObjectsFromArray:[[ContactManager sharedInstance] getContact]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRadius:5];
        [_tableView setAllowsMultipleSelection:YES];
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:nil];
        [_tableView reloadData];
        [_titleLabel setText:@"동기화"];
        
        [_bottomView setHidden:NO];
        [_bottomView2 setHidden:YES];
    }else if(_type == kViewType_sms){
        [_popupView setRadius:10];
        _contactsArray = [NSMutableArray new];
        NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
        [_contactsArray addObjectsFromArray:[Util stringConvertArray:contacts]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRadius:5];
        [_tableView setAllowsMultipleSelection:YES];
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:nil];
        [_tableView reloadData];
        [_titleLabel setText:@"단체문자"];
        
        [_bottomView setHidden:YES];
        [_bottomView2 setHidden:NO];
    }else if(_type == kViewType_groupSms){
        [_popupView setRadius:10];
        _contactsArray = [NSMutableArray new];
        for(NSString * key in _dataDict.allKeys){
            [_contactsArray addObject:[_dataDict objectForKey:key]];
        }
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRadius:5];
        [_tableView setAllowsMultipleSelection:YES];
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:nil];
        [_tableView reloadData];
        [_titleLabel setText:@"단체문자"];
        
        [_bottomView setHidden:YES];
        [_bottomView2 setHidden:NO];
        
    }
    

}


#pragma mark - UITableView Delegate Methods

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
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"memoTableViewCell";
    SyncTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"SyncTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.titleLabel setText:[[_contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell.phoneLabel setText:[[_contactsArray objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_saveDict objectForKey:indexPath] == nil) {
        [_saveDict setObject:[_contactsArray objectAtIndex:indexPath.row] forKey:indexPath];
    }else{
        [_saveDict removeObjectForKey:indexPath];
    }
}

#pragma mark - Action Methods
- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

- (IBAction)allAction:(id)sender {
    
    [[GUIManager sharedInstance] showComfirm:@"전체 목록을 저장 하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
        for(NSDictionary * dict in _contactsArray){
            [dict setValue:@"" forKey:@"image"];
        }
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[NSDictionary dictionaryWithObject:_contactsArray forKey:@"data"]];
    } cancelHandler:^(UIAlertAction *action) {
        
    }];

}

- (IBAction)saveAction:(id)sender {
    NSMutableArray * save = [NSMutableArray new];
    for (NSString * key in [_saveDict allKeys]) {
        [save addObject:[_saveDict objectForKey:key]];
    }
    
    [[GUIManager sharedInstance] showComfirm:[NSString stringWithFormat:@"%d개의 목록을 저장 하시겠습니까?",(int)[save count]] viewCon:self handler:^(UIAlertAction *action) {
         [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[NSDictionary dictionaryWithObject:save forKey:@"data"]];
    } cancelHandler:^(UIAlertAction *action) {
        
    }];
}

- (IBAction)sendAction:(id)sender {
    MFMessageComposeViewController * sms = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSMutableArray * save = [NSMutableArray new];
        for (NSString * key in [_saveDict allKeys]) {
            [save addObject:[[_saveDict objectForKey:key] objectForKey:@"phoneNumber"]];
        }
        
        sms.body = @"";
        sms.recipients = save;
        sms.messageComposeDelegate = self;
        [self presentViewController:sms animated:YES completion:nil];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

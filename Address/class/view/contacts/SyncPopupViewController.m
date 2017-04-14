//
//  SyncPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 14..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SyncPopupViewController.h"
#import "SyncTableViewCell.h"

@interface SyncPopupViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *allBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

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
    [_popupView setRadius:10];
    _contactsArray = [NSMutableArray new];
    [_contactsArray addObjectsFromArray:[[ContactManager sharedInstance] getContact]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setRadius:5];
//    [_tableView setBackgroundColor:RGB(250, 254, 243)];
    [_tableView setAllowsMultipleSelection:YES];
    [_tableView setTableHeaderView:nil];
    [_tableView setTableFooterView:nil];
    [_tableView reloadData];
    

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
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:@"전체 목록을 저장 하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];
    [av addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[NSDictionary dictionaryWithObject:_contactsArray forKey:@"data"]];
    }]];
    [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }]];
    [self presentViewController:av animated:YES completion:nil];
}

- (IBAction)saveAction:(id)sender {
    NSMutableArray * save = [NSMutableArray new];
    for (NSString * key in [_saveDict allKeys]) {
        [save addObject:[_saveDict objectForKey:key]];
    }
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:[NSString stringWithFormat:@"%d개의 목록을 저장 하시겠습니까?",(int)[save count]] preferredStyle:UIAlertControllerStyleAlert];
    [av addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[NSDictionary dictionaryWithObject:save forKey:@"data"]];

    }]];
    [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }]];
    [self presentViewController:av animated:YES completion:nil];
}

@end

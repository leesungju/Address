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
#import "SyncPopupViewController.h"

@interface ContactsViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *retTableView;
@property (strong, nonatomic) NSMutableDictionary * sections;
@property (strong, nonatomic) NSMutableDictionary * oriSections;
@property (strong, nonatomic) NSMutableArray * sectionArray;
@property (strong, nonatomic) NSMutableArray * oriDataArray;
@property (strong, nonatomic) NSString * searchStr;
@property (assign, nonatomic) BOOL isLoad;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSMutableArray * favArray;

@end

@implementation ContactsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oriDataArray = [NSMutableArray new];
        _favArray = [NSMutableArray new];
        _isLoad = NO;
        _isSearching = NO;
        
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
    [self.menuBtn setHidden:NO];
    
    if(_isSearching)return;
    if(_isLoad){
       [self initData];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"등록", @"동기화", @"단체문자", @"백업", nil] delegate:self];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"등록", @"동기화", @"단체문자", @"백업", nil] delegate:self];
    
    if(_isSearching)return;
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
    
    [self initData];
}

- (void)initData
{
    [_favArray removeAllObjects];
    [_oriDataArray removeAllObjects];
    NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
    NSArray * array = [Util stringConvertArray:contacts];
    
    [_oriDataArray addObjectsFromArray:array];
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:_oriDataArray];
    [_oriDataArray removeAllObjects];
    [_oriDataArray addObjectsFromArray:[orderedSet array]];
    
    for(int i =0;i<[_oriDataArray count];i++){
        BOOL isFav = [[[_oriDataArray objectAtIndex:i] objectForKey:@"isFav"] boolValue];
        if(isFav){
            AddressObj * address = [AddressObj new];
            [address setDict:[_oriDataArray objectAtIndex:i]];
            [_favArray addObject:address];
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [_favArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
        }
    }
    
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
            [contact setIndex:-1];
            [contact setSection:(int)[_sectionArray count]-1];
            [contact viewMode:kViewMode_add];
            [[GUIManager sharedInstance] hideSetting];
            [[GUIManager sharedInstance] moveToController:contact animation:YES];
            break;
        }
        case 2: {
            
            SyncPopupViewController * sync = [SyncPopupViewController new];
            [sync setType:kViewType_Snyc];
            [[GUIManager sharedInstance] showPopup:sync animation:YES complete:^(NSDictionary *dict) {
                if(dict != nil){
                    [_oriDataArray addObjectsFromArray:[dict objectForKey:@"data"]];
                    NSString * resultString = [Util arrayConvertJsonString:_oriDataArray];
                    [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
                }
                [self settingTableView:_oriDataArray];
            }];
            
            break;
        }
        case 3:{
            SyncPopupViewController * sync = [SyncPopupViewController new];
            [sync setType:kViewType_sms];
            [sync setContactArray:_oriDataArray];
            [[GUIManager sharedInstance] showPopup:sync animation:YES complete:^(NSDictionary *dict) {
                
            }];
            break;
        }
        case 4:{
            
            UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:@"1. 현재 정보는 저장된 정보로 변경됩니다.\n2. 프로필 사진은 저장되지 않습니다." preferredStyle:UIAlertControllerStyleAlert];
            [av addAction:[UIAlertAction actionWithTitle:@"저장하기" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"알림"
                                                                                          message: @"전화번호를 입력하세요! (예:01012341234)"
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Phone";
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.borderStyle = UITextBorderStyleRoundedRect;
                }];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSArray * textfields = alertController.textFields;
                    UITextField * urlTextField = textfields[0];
                    if([Util checkPhone:[NSStrUtils replacePhoneNumber:urlTextField.text]]){
                        NSString * hash = [NSStrUtils md5:[NSStrUtils replacePhoneNumber:urlTextField.text]];
                        NSString * contacts = [[PreferenceManager sharedInstance] getPreference:@"contacts" defualtValue:@""];
                        [[StorageManager sharedInstance] savebackupContacts:contacts forKey:hash];
                        [[GUIManager sharedInstance] showAlert:@"저장되었습니다." viewCon:self handler:nil];
                    }else{
                        [[GUIManager sharedInstance] showAlert:@"전화번호를 확인후 재시도 해주세요!" viewCon:self handler:nil];
                    }
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }]];;
            [av addAction:[UIAlertAction actionWithTitle:@"불러오기" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"알림"
                                                                                          message: @"전화번호를 입력하세요! (예:01012341234)"
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Phone";
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.borderStyle = UITextBorderStyleRoundedRect;
                }];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSArray * textfields = alertController.textFields;
                    UITextField * urlTextField = textfields[0];
                    NSString * hash = [NSStrUtils md5:[NSStrUtils replacePhoneNumber:urlTextField.text]];
                    [[GUIManager sharedInstance] showLoading];
                    [[StorageManager sharedInstance] loadBackupContacts:hash withBlock:^(FIRDataSnapshot *snapshot) {
                        NSString * contacts = snapshot.value ;
                        if(contacts.length > 0){
                            [[PreferenceManager sharedInstance] setPreference:contacts forKey:@"contacts"];
                            NSArray * array = [Util stringConvertArray:contacts];
                            [_oriDataArray removeAllObjects];
                            [_oriDataArray addObjectsFromArray:array];
                            
                            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:_oriDataArray];
                            [_oriDataArray removeAllObjects];
                            [_oriDataArray addObjectsFromArray:[orderedSet array]];
                            
                            [self settingTableView:_oriDataArray];
                            [[GUIManager sharedInstance] hideLoading];
                            [[GUIManager sharedInstance] showAlert:@"성공하였습니다." viewCon:self handler:nil];
                        }else{
                            [[GUIManager sharedInstance] showAlert:@"저장된 데이터가 없습니다." viewCon:self handler:nil];
                        }

                    } withCancelBlock:^(NSError *error) {
                        
                    }];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }]];
            [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:av animated:YES completion:nil];
            
            
            
            break;
        }
        default:
            break;
    }
    
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
    if([_favArray count] > 0){
        [_sectionArray insertObject:@"즐겨찾기" atIndex:0];
        [_sections setObject:_favArray forKey:@"즐겨찾기"];
    }
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
    NSMutableArray * fav = [NSMutableArray new];
    for(NSString * key in [dict allKeys]){
        if(![key isEqualToString:@"즐겨찾기"]){
            for (AddressObj *obj in [dict objectForKey:key]) {
                [save addObject:obj.getDict];
            }
        }else{
            for (AddressObj *obj in [dict objectForKey:key]) {
                [fav addObject:obj.getDict];
            }
        }
    }
    NSString * resultString = ([save count]> 0)?[Util arrayConvertJsonString:save]:@"";
    [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
    
    NSString * resultString2 = ([fav count]> 0)?[Util arrayConvertJsonString:fav]:@"";
    [[PreferenceManager sharedInstance] setPreference:resultString2 forKey:@"fav_contacts"];
    
    NSArray * array = [Util stringConvertArray:resultString];
    [_oriDataArray removeAllObjects];
    [_oriDataArray addObjectsFromArray:array];
}

#pragma textfield delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(_searchStr.length > 0){
        [self searchText];
    }else {
        _isSearching = NO;
        [self settingTableView:_oriDataArray];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _searchStr = @"";
    [self settingTableView:_oriDataArray];
    _isSearching = NO;
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
    
    
    if([temp.image isKindOfClass:[UIImage class]]){
        [cell.profileImageView setImage:temp.image];
    }else if(temp.imagePath.length > 0){
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:temp.imagePath];
        if(image){
            [cell.profileImageView setImage:image];
        }else{
            [cell.profileImageView setImage:[UIImage imageNamed:@"profile"]];
        }
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
    [self reloadFavArray];
    ContactsDetailViewController * contact = [ContactsDetailViewController new];
    if([_favArray count] > 0 && indexPath.section == 0){
        NSArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
        AddressObj *temp = [tempArray objectAtIndex:indexPath.row];
        
        [_sectionArray removeObjectAtIndex:0];
        [contact.sectionArray addObjectsFromArray:_sectionArray];
        contact.dataDict = _sections;
        [contact setIndex:[temp.favRow intValue]];
        [contact setSection:[temp.favSection intValue]];
        [_sections removeObjectForKey:@"즐겨찾기"];

    }else{
        if([_favArray count] > 0){
            [_sectionArray removeObjectAtIndex:0];
            [contact.sectionArray addObjectsFromArray:_sectionArray];
            contact.dataDict = _sections;
            [contact setIndex:(int)indexPath.row];
            [contact setSection:(int)indexPath.section-1];
            [_sections removeObjectForKey:@"즐겨찾기"];
        }else{
            [contact.sectionArray addObjectsFromArray:_sectionArray];
            contact.dataDict = _sections;
            [contact setIndex:(int)indexPath.row];
            [contact setSection:(int)indexPath.section];
        }
    }
    [[GUIManager sharedInstance] moveToController:contact animation:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadFavArray];
    if([_favArray count] > 0 && indexPath.section == 0){
        [[GUIManager sharedInstance] showComfirm:@"즐겨 찾기를 해제 하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
            AddressObj * selectObj = [[_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            int row = [selectObj.favRow intValue];
            int section = [selectObj.favSection intValue]+1;
            
            AddressObj * obj = [[_sections objectForKey:[_sectionArray objectAtIndex:section]] objectAtIndex:row];
            obj.isFav = [NSNumber numberWithBool:NO];

            [[_sections objectForKey:[_sectionArray objectAtIndex:section]] removeObjectAtIndex:row];
            [[_sections objectForKey:[_sectionArray objectAtIndex:section]] insertObject:obj atIndex:row];
            
            NSMutableArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
            [tempArray removeObjectAtIndex:indexPath.row];
            if([tempArray count] == 0){
                [_sectionArray removeObjectAtIndex:indexPath.section];
            }
            [tableView reloadData];
            [self saveData:_sections];
        } cancelHandler:^(UIAlertAction *action) {
            
        }];

    }else if([_favArray count] > 0){
        [[GUIManager sharedInstance] showComfirm:@"삭제하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
            NSMutableArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
            AddressObj * selectObj = [tempArray objectAtIndex:indexPath.row];
            if(selectObj.isFav){
                NSMutableArray * favArray = [_sections objectForKey:[_sectionArray objectAtIndex:0]];
                for (AddressObj * obj in favArray) {
                    if([obj.name isEqualToString:selectObj.name] && [obj.phoneNumber isEqualToString:selectObj.phoneNumber]){
                        [favArray removeObject:obj];
                        break;
                    }
                }
                if([favArray count] == 0){
                    [_sectionArray removeObjectAtIndex:0];
                }else{
                    [_sections setObject:favArray forKey:[_sectionArray objectAtIndex:0]];
                }
            }
            [tempArray removeObjectAtIndex:indexPath.row];
            if([tempArray count] == 0){
                [_sectionArray removeObjectAtIndex:indexPath.section];
            }
            [tableView reloadData];
            [self reloadFavArray];
            [self saveData:_sections];
        } cancelHandler:^(UIAlertAction *action) {
            
        }];
    }else{
        [[GUIManager sharedInstance] showComfirm:@"삭제하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
            NSMutableArray* tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:indexPath.section]];
            [tempArray removeObjectAtIndex:indexPath.row];
            if([tempArray count] == 0){
                [_sectionArray removeObjectAtIndex:indexPath.section];
            }
            [tableView reloadData];
            [self saveData:_sections];
        } cancelHandler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)reloadFavArray
{
    NSMutableArray * favArray = [_sections objectForKey:[_sectionArray objectAtIndex:0]];
    for (int k=0; k<[favArray count]; k++) {
        AddressObj * favObj = [favArray objectAtIndex:k];
        for(int i=0;i<[_sectionArray count];i++){
            if([[_sectionArray objectAtIndex:i] isEqualToString:favObj.section]){
                NSMutableArray * tempArray = [_sections objectForKey:[_sectionArray objectAtIndex:i]];
                for (int j=0; j<[tempArray count]; j++) {
                    AddressObj * obj = [tempArray objectAtIndex:j];
                    if([favObj.name isEqualToString:obj.name] && [favObj.phoneNumber isEqualToString:obj.phoneNumber]){
                        favObj.favSection = [NSNumber numberWithInt:i-1];
                        favObj.favRow = [NSNumber numberWithInt:j];
                        break;
                    }
                }
                break;
            }
        }
    }
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
    _isSearching = YES;
    [_sectionArray removeAllObjects];
    for (NSString * key in [_sections allKeys]){
        if(![key isEqualToString:@"즐겨찾기"]){
            AutoCompleteMng * automng = [[AutoCompleteMng alloc] initWithData:[_sections objectForKey:key] className:@"AddressObj"];
            NSArray* filteredData = [automng search:_searchStr];
            if([filteredData count] > 0){
                [_sections setObject:filteredData forKey:key];
                [_sectionArray addObject:key];
            }
        }
    }
    
    [_retTableView reloadData];
}


@end

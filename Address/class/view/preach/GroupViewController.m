//
//  GroupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupTableViewCell.h"
#import "CreateGroupPopupViewController.h"
#import "AutoCompleteMng.h"

@interface GroupViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GroupTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *retTableView;

@property (strong, nonatomic) NSMutableArray * groupArray;
@property (strong, nonatomic) NSArray * oriArray;

@property (strong, nonatomic) NSString * searchStr;

@end

@implementation GroupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _groupArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"그룹생성", nil] delegate:self];
    [self setViewLayout];
    [self selectTabMenu:1];
    [self initViews];
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)initViews
{
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
    [self dataReset];
}

- (void)dataReset
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[StorageManager sharedInstance] loadGroupWithBlock:^(FIRDataSnapshot *snapshot) {
            [_groupArray removeAllObjects];
            NSMutableDictionary * groupDict = (NSMutableDictionary*)snapshot.value;
            if(![groupDict isKindOfClass:[NSNull class]]){
                for (NSDictionary * temp in [groupDict allKeys]){
                    [_groupArray addObject:[groupDict objectForKey:temp]];
                }
                _oriArray = [_groupArray copy];
                
                NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"memberCount" ascending:NO];
                [_groupArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
                
                
                [_retTableView reloadData];
            }
        } withCancelBlock:^(NSError *error) {
            
        }];
    });
}

- (void)menuClicked:(int)index
{
    [super menuClicked:index];
    switch (index) {
        case 0:
            
            break;
        case 1:{
            CreateGroupPopupViewController * groupPopupView = [CreateGroupPopupViewController new];
            [groupPopupView setType:kGroupViewType_add];
            [[GUIManager sharedInstance] showPopup:groupPopupView animation:YES complete:^(NSDictionary *dict) {
                if(dict){
                    [_groupArray removeAllObjects];
                    if(![dict isKindOfClass:[NSNull class]]){
                        for (NSDictionary * temp in [dict allKeys]){
                            [_groupArray addObject:[dict objectForKey:temp]];
                        }
                        [_retTableView reloadData];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark tableview delgate, datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"groupTableViewCell";
    GroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"GroupTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        [cell setDelegate:self];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupObj * group = [GroupObj new];
    [group setDict:[_groupArray objectAtIndex:indexPath.row]];
    
    [cell setGroup:group];
    [cell.titleLabel setText:group.groupContents];
    [cell.countLabel setText:[NSString stringWithFormat:@"%d",[group.memberCount intValue]]];
    [cell.dateLabel setText:group.createDt];
    if([group.memberCount intValue] > 0){
        for (NSDictionary * key in [group.member allKeys]) {
            if([[[group.member objectForKey:key] objectForKey:@"memberId"] isEqualToString:[UIDevice getDeviceId]]){
                [cell.starImageView setImage:[UIImage imageNamed:@"star_sel"]];
                [cell.joinButton setEnabled:NO];
            }else{
                [cell.starImageView setImage:[UIImage imageNamed:@"star_no_sel"]];
                [cell.joinButton setEnabled:YES];
            }
        }
    }else{
        [cell.starImageView setImage:[UIImage imageNamed:@"star_no_sel"]];
        [cell.joinButton setEnabled:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupObj * group = [GroupObj new];
    [group setDict:[_groupArray objectAtIndex:indexPath.row]];
    if([group.memberCount intValue] > 0){
        for (NSDictionary * key in [group.member allKeys]) {
            if([[[group.member objectForKey:key] objectForKey:@"memberId"] isEqualToString:[UIDevice getDeviceId]]){
                
            }else{
                [self showAlert:@"그룹에 가입되지 않았습니다. 가입후 이용해 주세요."];
            }
        }
    }else{
        [self showAlert:@"그룹에 가입되지 않았습니다. 가입후 이용해 주세요."];
    }
    
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

#pragma mark - GroupTableViewCellDelegate Methods

- (void)selectJoinBtn:(GroupObj *)group
{
    if([group.publicType intValue] == 1){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"알림"
                                                                                  message: @"비공개 그룹입니다. 비밀번호를 입력해주세요"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"password";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * passwordfiled = textfields[0];
            if([group.pwd isEqualToString:passwordfiled.text]){
                MemberObj * member = [MemberObj new];
                [member setMemberId:[UIDevice getDeviceId]];
                [member setName:[UIDevice getName]];
                [member setPhoneNumber:[UIDevice getPhoneNumber]];
                [member setPermission:[NSNumber numberWithInt:0]];
                [[StorageManager sharedInstance] joinGroup:[member getDict] forKey:group.groupId];
                [self dataReset];
            }else{
                [self showAlert:@"비밀번호를 확인후 재시도 해주세요"];
            }
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        MemberObj * member = [MemberObj new];
        [member setMemberId:[UIDevice getDeviceId]];
        [member setName:[UIDevice getName]];
        [member setPhoneNumber:[UIDevice getPhoneNumber]];
        [member setPermission:[NSNumber numberWithInt:0]];
        [[StorageManager sharedInstance] joinGroup:[member getDict] forKey:group.groupId];
        [self dataReset];
    }
}

#pragma textfield delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(_searchStr.length > 0){
        [self searchText];
    }else {
        [_groupArray removeAllObjects];
        [_groupArray addObjectsFromArray:_oriArray];
        [_retTableView reloadData];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _searchStr = @"";
    [_groupArray removeAllObjects];
    [_groupArray addObjectsFromArray:_oriArray];
    [_retTableView reloadData];
    return YES;
}

#pragma mark - search medhods

- (void)searchText
{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary * temp in _groupArray){
        GroupObj * group = [GroupObj new];
        [group setDict:temp];
        [tempArray addObject:group];
    }
    AutoCompleteMng * automng = [[AutoCompleteMng alloc] initWithData:tempArray className:@"GroupObj"];
    NSArray* filteredData = [automng search:_searchStr];
    [_groupArray removeAllObjects];
    for (GroupObj * temp in filteredData){
        [_groupArray addObject:[temp getDict]];
    }
    [_retTableView reloadData];
}

#pragma mark - Util Methods
- (void)showAlert:(NSString*)message
{
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:message preferredStyle:UIAlertControllerStyleAlert];\
    [av addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                   {
                   }]];
    [self presentViewController:av animated:YES completion:nil];

}

@end

//
//  GroupDetailViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "GroupContentsViewController.h"
#import "GroupContentsTableViewCell.h"
#import "CreateGroupPopupViewController.h"

@interface GroupDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *contentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentsCountLabel;
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

@property (strong, nonatomic) NSMutableArray * contentsArray;
@property (assign, nonatomic) BOOL isAdmin;

@end

@implementation GroupDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentsArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if([_contentsArray count] > 0) return;
    if([_member.permission integerValue] == 1){
        _isAdmin = YES;
        [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"글작성",@"그룹정보", @"그룹삭제", nil] delegate:self];
    }else{
        _isAdmin = NO;
        [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈",@"그룹탈퇴", nil] delegate:self];
    }
    [self setViewLayout];
    [self.bottomTabView setHidden:YES];
    [self initViews];
}

- (void)initViews
{
    [_contentsCountLabel setText:[NSString stringWithFormat:@"%d",[_group.contentsCount intValue]]];
    [_contentsLabel setText:_group.groupContents];
    [_detailTableView setDelegate:self];
    [_detailTableView setDataSource:self];
    [_detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _detailTableView.tableHeaderView = nil;
    [self dataReset];
}

- (void)dataReset
{
    [[GUIManager sharedInstance] showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[StorageManager sharedInstance] loadContents:_group.groupId withBlock:^(FIRDataSnapshot *snapshot) {
            [_contentsArray removeAllObjects];
            NSMutableDictionary * groupDict = (NSMutableDictionary*)snapshot.value;
            if(![groupDict isKindOfClass:[NSNull class]]){
                for (NSDictionary * temp in [groupDict allKeys]){
                    [_contentsArray addObject:[groupDict objectForKey:temp]];
                }
                
                NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"createDt" ascending:NO];
                [_contentsArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
                [_contentsCountLabel setText:[NSString stringWithFormat:@"%d", (int)[_contentsArray count]]];
                [_detailTableView reloadData];
            }
            [[GUIManager sharedInstance] hideLoading];
            
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
            if(_isAdmin){
                GroupContentsViewController * contentPopupView = [GroupContentsViewController new];
                [contentPopupView setType:kGroupContentsViewType_add];
                [contentPopupView setGroup:_group];
                [[GUIManager sharedInstance] showPopup:contentPopupView animation:YES complete:^(NSDictionary *dict) {
                    if(dict){
                        [self dataReset];
                    }
                }];
            }else{
                [[GUIManager sharedInstance] showComfirm:@"해당 그룹을 탈퇴 하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
                    [[StorageManager sharedInstance] removeMemberWithGroup:_group.groupId forKey:_member.memberId];
                    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
                } cancelHandler:^(UIAlertAction *action) {
                    
                }];
            }
            break;
        }
        case 2:{
            CreateGroupPopupViewController * groupPopupView = [CreateGroupPopupViewController new];
            [groupPopupView setGroupObj:_group];
            [groupPopupView setType:kGroupViewType_nomarl];
            [[GUIManager sharedInstance] showPopup:groupPopupView animation:YES complete:^(NSDictionary *dict) {
                if(dict){
                    [self dataReset];
                }
            }];
            break;
        }
        case 3:{
            [[GUIManager sharedInstance] showComfirm:@"그룹을 삭제하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
                [[StorageManager sharedInstance] removeGroupKey:_group.groupId];
                [[GUIManager sharedInstance] backControllerWithAnimation:YES];
            } cancelHandler:^(UIAlertAction *action) {
                
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
    return [_contentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"groupContentsTableViewCell";
    GroupContentsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"GroupContentsTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ContentsObj * contents = [ContentsObj new];
    [contents setDict:[_contentsArray objectAtIndex:indexPath.row]];
    
    [cell.titleLabel setText:contents.contentsTitle];
    [cell.dateLabel setText:contents.createDt];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentsObj * contents = [ContentsObj new];
    [contents setDict:[_contentsArray objectAtIndex:indexPath.row]];
    
    GroupContentsViewController * contentPopupView = [GroupContentsViewController new];
    [contentPopupView setType:kGroupContentsViewType_nomarl];
    [contentPopupView setGroup:_group];
    [contentPopupView setContentsObj:contents];
    [[GUIManager sharedInstance] showPopup:contentPopupView animation:YES complete:^(NSDictionary *dict) {
        if(dict){
            [self dataReset];
        }
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentsObj * contents = [ContentsObj new];
    [contents setDict:[_contentsArray objectAtIndex:indexPath.row]];
    [[GUIManager sharedInstance] showComfirm:@"삭제하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
        [[StorageManager sharedInstance] removeContents:_group.groupId forKey:contents.contentsId];
        [self dataReset];
    } cancelHandler:^(UIAlertAction *action) {
        
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isAdmin){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Action Methods

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

@end

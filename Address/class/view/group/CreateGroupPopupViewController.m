//
//  CreateGroupPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "CreateGroupPopupViewController.h"
#import "SyncPopupViewController.h"

@interface CreateGroupPopupViewController ()

@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet UITextView *normalTextView;
@property (strong, nonatomic) IBOutlet UIButton *normalPublicBtn;
@property (strong, nonatomic) IBOutlet UILabel *memberLabel;
@property (strong, nonatomic) IBOutlet UIView *memberView;
@property (strong, nonatomic) IBOutlet UIView *contentsView;
@property (strong, nonatomic) IBOutlet UILabel *contentsLabel;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextView *contentsTextView;
@property (strong, nonatomic) IBOutlet UIButton *publicBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateBtn;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;

@property (strong, nonatomic) NSString * groupId;
@property (strong, nonatomic) MemberObj * member;
@property (assign, nonatomic) BOOL isPublic;
@end

@implementation CreateGroupPopupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPublic = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addTapGestureTarget:self action:@selector(backgroundTouch:)];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initViews];
}

- (void)initViews
{
    [_popupView setRadius:10];
    _member = [MemberObj new];
    [_member setName:[UIDevice getName]];
    [_member setMemberId:[UIDevice getDeviceId]];
    [_member setPhoneNumber:[UIDevice getPhoneNumber]];
    [_member setPermission:[NSNumber numberWithInt:0]];
    [_member setPushToken:[UIDevice getPushToken]];
    [_member setImagePath:[UIDevice getImagePath]];
    
    if(_type == kGroupViewType_nomarl){

        [_titleLabel setText:@"그룹 정보"];
        [_editView setHidden:YES];
        [_normalView setHidden:NO];
        [_normalTextView setText:_groupObj.groupContents];
        [_normalTextView setRadius:5];
        [_normalTextView setEditable:NO];
        [_normalPublicBtn setRadius:5];
        if([_groupObj.publicType intValue] == 1){
            [_normalPublicBtn setTitle:@"비공개" forState:UIControlStateNormal];
        }else{
            [_normalPublicBtn setTitle:@"공개" forState:UIControlStateNormal];
            [_normalPublicBtn setEnabled:NO];
        }
        [_memberView setRadius:5];
        [_memberView addTapGestureTarget:self action:@selector(smsAction:)];
        [_memberLabel setText:[NSString stringWithFormat:@"%d",[_groupObj.memberCount intValue]]];
        
        [_contentsView setRadius:5];
        [_contentsLabel setText:[NSString stringWithFormat:@"%d",[_groupObj.contentsCount intValue]]];
        [_addBtn setTitle:@"수정" forState:UIControlStateNormal];

    }else if(_type == kGroupViewType_add){

        [_titleLabel setText:@"그룹 생성"];
        [self selectPublic:_isPublic];
        [_editView setHidden:NO];
        [_normalView setHidden:YES];
        [_pwdTextField setSecureTextEntry:YES];
        [_addBtn setTitle:@"추가" forState:UIControlStateNormal];

    }else if(_type == kGroupViewType_edit){
        [_titleLabel setText:@"그룹 수정"];
        [_editView setHidden:NO];
        [_normalView setHidden:YES];
        if([_groupObj.publicType intValue] == 1){
            [self selectPublic:NO];
        }else{
            [self selectPublic:YES];
        }
        [_pwdTextField setSecureTextEntry:YES];
        [_pwdTextField setText:_groupObj.pwd];
        [_contentsTextView setText:_groupObj.groupContents];

        [_addBtn setTitle:@"추가" forState:UIControlStateNormal];
    }
}

- (void)selectPublic:(BOOL)isSelect
{
    if(isSelect){
        _isPublic = YES;
        [_publicBtn setBackgroundColor:RGB(250, 215, 134)];
        [_privateBtn setBackgroundColor:RGB(250, 254, 243)];
        [_pwdTextField setEnabled:NO];
    }else{
        _isPublic = NO;
        [_publicBtn setBackgroundColor:RGB(250, 254, 243)];
        [_privateBtn setBackgroundColor:RGB(250, 215, 134)];
        [_pwdTextField setEnabled:YES];
    }
}



#pragma mark - action Methods

- (IBAction)publicAction:(id)sender {
    [self selectPublic:YES];
}

- (IBAction)privateAction:(id)sender {
    [self selectPublic:NO];
}

- (IBAction)addAction:(id)sender {
    if(_type == kGroupViewType_nomarl){
        _type = kGroupViewType_edit;
        [self initViews];
    }else if(_type == kGroupViewType_add){
        
        _groupObj = [GroupObj new];
        [_groupObj setGroupContents:_contentsTextView.text];
        if(_isPublic){
            [_groupObj setPwd:@""];
            [_groupObj setPublicType:[NSNumber numberWithInt:0]];
        }else{
            [_groupObj setPwd:_pwdTextField.text];
            [_groupObj setPublicType:[NSNumber numberWithInt:1]];
        }
        [_groupObj setGroupId:[Util timeStamp]];
        [_groupObj setCreateDt:[Util dateConvertString:[NSDate new]]];
        [_groupObj setPushId:_groupObj.groupId];
        [_member setPermission:[NSNumber numberWithInt:1]];
        
        [[StorageManager sharedInstance] saveGroup:[_groupObj getDict] forKey:_groupObj.groupId];
        [[StorageManager sharedInstance] joinGroup:[_member getDict] forKey:_groupObj.groupId];
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_groupObj getDict]];
        
    }else if(_type == kGroupViewType_edit){
        [_groupObj setGroupContents:_contentsTextView.text];
        if(_isPublic){
            [_groupObj setPwd:@""];
            [_groupObj setPublicType:[NSNumber numberWithInt:0]];
        }else{
            [_groupObj setPwd:_pwdTextField.text];
            [_groupObj setPublicType:[NSNumber numberWithInt:1]];
        }
        [_groupObj setCreateDt:[Util dateConvertString:[NSDate new]]];
        
        [[StorageManager sharedInstance] saveGroup:[_groupObj getDict] forKey:_groupObj.groupId];
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_groupObj getDict]];
    }
}

- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

- (void)backgroundTouch:(id)sender
{
    [_pwdTextField resignFirstResponder];
    [_contentsTextView resignFirstResponder];

}

- (IBAction)normalPublicAction:(id)sender {
    [[GUIManager sharedInstance] showComfirm:@"비밀번호를 확인하시겠습니까?" viewCon:self handler:^(UIAlertAction *action) {
        [[GUIManager sharedInstance] showAlert:_groupObj.pwd viewCon:self handler:nil];
    } cancelHandler:^(UIAlertAction *action) {
        
    }];
}

- (void)smsAction:(id)sender
{
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
    [[StorageManager sharedInstance] loadMember:_groupObj.groupId withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary * dict = snapshot.value;
        SyncPopupViewController * sync = [SyncPopupViewController new];
        [sync setType:kViewType_groupSms];
        [sync setDataDict:dict];
        [[GUIManager sharedInstance] showPopup:sync animation:YES complete:^(NSDictionary *dict) {
            
        }];

    } withCancelBlock:^(NSError *error) {
        
    }];
}
@end

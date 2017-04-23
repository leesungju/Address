//
//  CreateGroupPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "CreateGroupPopupViewController.h"

@interface CreateGroupPopupViewController ()

@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextView *contentsTextView;
@property (strong, nonatomic) IBOutlet UIButton *publicBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateBtn;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;

@property (strong, nonatomic) NSString * groupId;
@property (strong, nonatomic) MemberObj * member;
@end

@implementation CreateGroupPopupViewController

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
    [_pwdTextField setSecureTextEntry:YES];
    _member = [MemberObj new];
    [_member setName:[UIDevice getName]];
    [_member setMemberId:[UIDevice getDeviceId]];
    [_member setPhoneNumber:[UIDevice getPhoneNumber]];
    [_member setPermission:[NSNumber numberWithInt:0]];
    
    if(_type == kGroupViewType_nomarl){

        [_titleLabel setText:@"그룹 정보"];

    }else if(_type == kGroupViewType_add){

        [_titleLabel setText:@"그룹 생성"];
        [self selectPublic:YES];
        _groupObj = [GroupObj new];
        [_groupObj setGroupContents:_contentsTextView.text];
        if(_pwdTextField.text.length > 0){
            [_groupObj setPwd:_pwdTextField.text];
            [_groupObj setPublicType:[NSNumber numberWithInt:1]];
        }else{
            [_groupObj setPwd:@""];
            [_groupObj setPublicType:[NSNumber numberWithInt:0]];
        }
        _groupId = [Util timeStamp];
        [_groupObj setGroupId:_groupId];
        [_groupObj setCreateDt:[Util dateConvertString:[NSDate new]]];
        [_member setPermission:[NSNumber numberWithInt:1]];

    }else if(_type == kGroupViewType_edit){

        [_titleLabel setText:@"그룹 수정"];
    }
}

- (void)selectPublic:(BOOL)isSelect
{
    if(isSelect){
        [_publicBtn setBackgroundColor:RGB(250, 215, 134)];
        [_privateBtn setBackgroundColor:RGB(208, 250, 138)];
        [_pwdTextField setEnabled:NO];
    }else{
        [_publicBtn setBackgroundColor:RGB(208, 250, 138)];
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
        
    }else if(_type == kGroupViewType_add){
        [[StorageManager sharedInstance] saveGroup:[_groupObj getDict] forKey:_groupObj.groupId];
        [[StorageManager sharedInstance] joinGroup:[_member getDict] forKey:_groupObj.groupId];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[StorageManager sharedInstance] loadGroupWithBlock:^(FIRDataSnapshot *snapshot) {
                NSMutableDictionary * groupDict = (NSMutableDictionary*)snapshot.value;
                [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:groupDict];
            } withCancelBlock:^(NSError *error) {
                
            }];
        });
        
    }else if(_type == kGroupViewType_edit){
        
    }
}

- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

#pragma mark - Action Methods
- (void)backgroundTouch:(id)sender
{
    [_pwdTextField resignFirstResponder];
    [_contentsTextView resignFirstResponder];

}

@end

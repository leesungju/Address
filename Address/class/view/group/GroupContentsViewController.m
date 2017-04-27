//
//  GroupContentsViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupContentsViewController.h"

@interface GroupContentsViewController ()

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *normalContentsLabel;
@property (strong, nonatomic) IBOutlet UIButton *normalFileBtn;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextField *editTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *editContentsTextView;
@property (strong, nonatomic) IBOutlet UIButton *editFileBtn;


@end

@implementation GroupContentsViewController

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
    if(!_contentsObj){
        _contentsObj = [ContentsObj new];
    }
    
    if(_type == kGroupContentsViewType_nomarl){
        
        [_normalView setHidden:NO];
        [_editView setHidden:YES];
        [_titleLabel setText:@"내용 상세"];
        [_normalTitleLabel setText:_contentsObj.contentsTitle];
        [_normalContentsLabel setText:_contentsObj.contents];
        [_normalContentsLabel setEditable:NO];
        [_saveBtn setTitle:@"수정" forState:UIControlStateNormal];
        if(_contentsObj.filePath.length > 0){
            [_normalFileBtn setEnabled:YES];
        }else{
            [_normalFileBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_normalFileBtn setEnabled:NO];
        }
        
    }else if(_type == kGroupContentsViewType_add){
        
        [_normalView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"내용 추가"];
        [_editContentsTextView setRadius:5];
        
    }else if(_type == kGroupContentsViewType_edit){
        
        [_normalView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"내용 수정"];
        [_editContentsTextView setRadius:5];
        [_saveBtn setTitle:@"저장" forState:UIControlStateNormal];
        
        [_editTitleTextField setText:_contentsObj.contentsTitle];
        [_editContentsTextView setText:_contentsObj.contents];
    }
}

#pragma mark - Action Methods

- (void)backgroundTouch:(id)sender
{
    [_editTitleTextField resignFirstResponder];
    [_editContentsTextView resignFirstResponder];
    
}

- (IBAction)addAction:(id)sender {
    
    if(_type == kGroupContentsViewType_nomarl){
        _type = kGroupContentsViewType_edit;
        [self initViews];
        
    }else if(_type == kGroupContentsViewType_add){
        [_contentsObj setContentsTitle:_editTitleTextField.text];
        [_contentsObj setContents:_editContentsTextView.text];
        [_contentsObj setCreateDt:[Util fullDateConvertString:[NSDate new]]];
        [_contentsObj setContentsId:[Util timeStamp]];
        [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
        NSString * message = [NSString stringWithFormat:@"'%@'의 글이 1건이 등록 되었습니다.", _group.groupContents];
        [[PushManager sharedInstance] makePushMessage:_group.groupId message:message];
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
        
        
        
    }else if(_type == kGroupContentsViewType_edit){
        [_contentsObj setContentsTitle:_editTitleTextField.text];
        [_contentsObj setContents:_editContentsTextView.text];
        [_contentsObj setCreateDt:[Util fullDateConvertString:[NSDate new]]];
        [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

- (IBAction)normalfileBtnAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_contentsObj.filePath] options:@{} completionHandler:nil];
}


- (IBAction)editFileBtnAction:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"알림"
                                                                              message: @"파일 URL을 입력해 주세요!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"File URL";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * urlTextField = textfields[0];
        [_contentsObj setFilePath:urlTextField.text];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

@end

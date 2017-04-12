//
//  ContactsDetailViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 8..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "MemoPopupViewController.h"
#import "MemoTableViewCell.h"

@interface ContactsDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailBrithDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailFamilyLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailMemoBtn;
@property (strong, nonatomic) IBOutlet UITableView *detailMemoTableView;
@property (strong, nonatomic) NSArray * memoArray;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UIImageView *editImageView;
@property (strong, nonatomic) IBOutlet UITextField *editNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *editPhoneextField;
@property (strong, nonatomic) IBOutlet UITextField *editBrithDayextField;
@property (strong, nonatomic) IBOutlet UITextField *editGroupextField;
@property (strong, nonatomic) IBOutlet UITextField *editEmailextField;
@property (strong, nonatomic) IBOutlet UITextField *editAddressextField;
@property (strong, nonatomic) IBOutlet UITextView *editFamilyTextView;

@property (assign, nonatomic) kViewMode viewMode;
@property (strong, nonatomic) NSString * imgPath;

@end

@implementation ContactsDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionArray = [NSMutableArray new];
        _dataDict = [NSMutableDictionary new];
        _viewMode = kViewMode_nomarl;
        _imgPath = @"";
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", nil] delegate:self];
    [self setViewLayout];
    [self.bottomTabView setHidden:YES];
    [self initViews];
}

- (void)initViews
{
    AddressObj * obj = [AddressObj new];
    if([_sectionArray count] > 0 && [_sectionArray count] != _section+1  && [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] count] != _index){
        obj = [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] objectAtIndex:_index];
    }else{
        obj.name = @"이름";
        obj.phoneNumber = @"핸드폰 번호";
        obj.birthDay = @"생일";
        obj.group = @"직장/학교/과";
        obj.email = @"이메일/소셜";
        obj.address = @"주소";
        obj.family = @"가족관계";
    }
    if(_viewMode == kViewMode_add){
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_editView setHidden:NO];
        [_detailView setHidden:YES];
        [_editNameTextField setPlaceholder:obj.name];
        [_editNameTextField setDelegate:self];
        [_editPhoneextField setPlaceholder:obj.phoneNumber];
        [_editPhoneextField setDelegate:self];
        [_editBrithDayextField setPlaceholder:obj.birthDay];
        [_editBrithDayextField setDelegate:self];
        [_editGroupextField setPlaceholder:obj.group];
        [_editGroupextField setDelegate:self];
        [_editEmailextField setPlaceholder:obj.email];
        [_editEmailextField setDelegate:self];
        [_editAddressextField setPlaceholder:obj.address];
        [_editAddressextField setDelegate:self];
        [_editFamilyTextView setText:obj.family];
        [_editFamilyTextView setDelegate:self];
        
    }else if(_viewMode == kViewMode_edit){
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_editView setHidden:NO];
        [_detailView setHidden:YES];
        [_editNameTextField setText:obj.name];
        [_editNameTextField setDelegate:self];
        [_editPhoneextField setText:obj.phoneNumber];
        [_editPhoneextField setDelegate:self];
        [_editBrithDayextField setText:obj.birthDay];
        [_editBrithDayextField setDelegate:self];
        [_editGroupextField setText:obj.group];
        [_editGroupextField setDelegate:self];
        [_editEmailextField setText:obj.email];
        [_editEmailextField setDelegate:self];
        [_editAddressextField setText:obj.address];
        [_editAddressextField setDelegate:self];
        [_editFamilyTextView setText:obj.family];
        [_editFamilyTextView setDelegate:self];
        
    }else{
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [_editView setHidden:YES];
        [_detailView setHidden:NO];
        if(obj.image){
            [_detailImageView setImage:obj.image];
        }else{
            [_detailImageView setImage:[UIImage imageNamed:@"profile"]];
        }
        [_detailNameLabel setText:obj.name];
        [_detailNameLabel setRadius:5];
        [_detailPhoneLabel setText:obj.phoneNumber];
        [_detailPhoneLabel setRadius:5];
        [_detailBrithDayLabel setText:obj.birthDay];
        [_detailBrithDayLabel setRadius:5];
        [_detailGroupLabel setText:obj.group];
        [_detailGroupLabel setRadius:5];
        [_detailEmailLabel setText:obj.email];
        [_detailEmailLabel setRadius:5];
        [_detailAddressLabel setText:obj.address];
        [_detailAddressLabel setRadius:5];
        [_detailFamilyLabel setText:obj.family];
        [_detailFamilyLabel setRadius:5];
        _memoArray = obj.memoArray;
        [_detailMemoTableView setDelegate:self];
        [_detailMemoTableView setDataSource:self];
        [_detailMemoTableView setRadius:5];
        [_detailMemoTableView setBackgroundColor:RGB(250, 254, 243)];
        if([_memoArray count] > 0){
            [_detailMemoTableView reloadData];
            [_detailMemoTableView setHidden:NO];
        }else{
            [_detailMemoTableView setHidden:YES];
        }
    }
}


- (void)viewMode:(kViewMode)mode
{
    _viewMode = mode;
    [self initViews];
}

- (void)saveData:(BOOL)isBack
{
    NSMutableArray * save = [NSMutableArray new];
    for(NSString * key in [_dataDict allKeys]){
        for (AddressObj *obj in [_dataDict objectForKey:key]) {
            NSMutableDictionary *dict = obj.getDict;
            [dict removeObjectForKey:@"image"];
            [save addObject:dict];
        }
    }
    NSString * resultString = [Util arrayConvertJsonString:save];
    [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
    if(isBack){
        [[GUIManager sharedInstance] backControllerWithAnimation:YES];
    }
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_memoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"memoTableViewCell";
    MemoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"MemoTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.titleLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [cell.detailLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"detail"]];
    [cell.dateLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressObj* obj = [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] objectAtIndex:_index];
    MemoPopupViewController * memo = [MemoPopupViewController new];
    [memo setViewMode:kViewPopupMode_nomarl];
    [memo setIndex:(int)indexPath.row];
    [memo setDataArray:[NSMutableArray arrayWithArray:_memoArray]];
    [[GUIManager sharedInstance] showPopup:memo animation:YES complete:^(NSDictionary *dict) {
        if(dict){
            [obj.memoArray addObject:dict];
            _memoArray = obj.memoArray;
            [_detailMemoTableView reloadData];
            [_detailMemoTableView setHidden:NO];
            [self saveData:NO];
        }
    }];
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressObj* obj = [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] objectAtIndex:_index];
    [obj.memoArray removeObjectAtIndex:indexPath.row];
    _memoArray = obj.memoArray;
    [_detailMemoTableView reloadData];
    [self saveData:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Action Methods

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

- (IBAction)editAction:(UIButton*)sender {
    if(_viewMode == kViewMode_add || _viewMode == kViewMode_edit){
        //저장
        AddressObj * obj = [AddressObj new];
        if(_editNameTextField.text.length > 0 && _editPhoneextField.text.length > 0){
            obj.name = _editNameTextField.text;
            obj.phoneNumber = _editPhoneextField.text;
            obj.birthDay = _editBrithDayextField.text;
            obj.group = _editGroupextField.text;
            obj.email = _editEmailextField.text;
            obj.family = _editFamilyTextView.text;
            obj.image = nil;
            obj.imagePath = _imgPath;
            obj.section = [[NSStrUtils getJasoLetter:obj.name] substringToIndex:1].uppercaseString;
            
            if(_viewMode == kViewMode_add){
                NSMutableArray * array = [_dataDict objectForKey:obj.section];
                if([array count]>0){
                    [array addObject:obj];
                }else{
                    array = [NSMutableArray new];
                    [array addObject:obj];
                    [_dataDict setObject:array forKey:obj.section];
                }
            }else{
                [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] removeObjectAtIndex:_index];
                [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] insertObject:obj atIndex:_index];
            }
            [self saveData:YES];
        }else{
            
        }
        
    }else{
        [self viewMode:kViewMode_edit];
        
    }
    
}

- (IBAction)imageAction:(id)sender {
    
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.allowsEditing = YES;
    [picker setDelegate:self];
    
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:@"선택하세요!" preferredStyle:UIAlertControllerStyleActionSheet];
    [av addAction:[UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                   {
                       [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                       [self presentViewController:picker animated:YES completion:nil];
                   }]];
    [av addAction:[UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                   {
                       [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                       [self presentViewController:picker animated:YES completion:nil];
                   }]];
    [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                   {
                       
                   }]];
    [self presentViewController:av animated:YES completion:nil];
}

- (IBAction)memoAction:(id)sender {
    AddressObj* obj = [[_dataDict objectForKey:[_sectionArray objectAtIndex:_section]] objectAtIndex:_index];
    MemoPopupViewController * memo = [MemoPopupViewController new];
    [memo setViewMode:kViewPopupMode_add];
    [memo setIndex:0];
    [memo setDataArray:obj.memoArray];
    [[GUIManager sharedInstance] showPopup:memo animation:YES complete:^(NSDictionary *dict) {
        if(dict){
            [obj.memoArray insertObject:dict atIndex:0];
            _memoArray = obj.memoArray;
            [_detailMemoTableView reloadData];
            [_detailMemoTableView setHidden:NO];
            [self saveData:NO];
        }
    }];
}

- (void)datePickerAction:(UIDatePicker*)sender
{
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy년 MM월 dd일"];
    _editBrithDayextField.text=[formate stringFromDate:sender.date];
}

- (void)selectDate:(id)sender
{
    [_editBrithDayextField resignFirstResponder];
}

#pragma mark - UIImagePicker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    [_editImageView setImage:img];
    [_imageBtn setAlpha:0.1];
    _imgPath = [Util saveImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _editBrithDayextField){
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        NSDateFormatter *formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy년 MM월 dd일"];
        _editBrithDayextField.text=[formate stringFromDate:[NSDate date]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
        [_editBrithDayextField setInputView:datePicker];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectDate:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [_editBrithDayextField setInputAccessoryView:toolBar];
    }
}


@end

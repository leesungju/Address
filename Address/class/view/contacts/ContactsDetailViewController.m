//
//  ContactsDetailViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 8..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ContactsDetailViewController.h"

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
        _totalDataArray = [NSMutableArray new];
        _viewMode = kViewMode_nomarl;
        _imgPath = @"";
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout:[NSArray new]];
    [self initViews];
}

- (void)initViews
{
    AddressObj * obj = [AddressObj new];
    if([_totalDataArray count] != _index){
        obj = [_totalDataArray objectAtIndex:_index];
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
        [_editBtn setTitle:@"save" forState:UIControlStateNormal];
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
        [_editBtn setTitle:@"save" forState:UIControlStateNormal];
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
        [_editBtn setTitle:@"edit" forState:UIControlStateNormal];
        [_editView setHidden:YES];
        [_detailView setHidden:NO];
        [_detailImageView setImage:obj.image];
        [_detailNameLabel setText:obj.name];
        [_detailPhoneLabel setText:obj.phoneNumber];
        [_detailBrithDayLabel setText:obj.birthDay];
        [_detailGroupLabel setText:obj.group];
        [_detailEmailLabel setText:obj.email];
        [_detailAddressLabel setText:obj.address];
        [_detailFamilyLabel setText:obj.family];
        _memoArray = obj.memoArray;
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

- (void)saveData
{
    NSString * resultString = [Util arrayConvertJsonString:_totalDataArray];
    [[PreferenceManager sharedInstance] setPreference:resultString forKey:@"contacts"];
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
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
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"selectCityTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil];
        //        cell=[nib objectAtIndex:0];
    }
    
    CALayer *separator = [CALayer layer];
    separator.frame = CGRectMake(0, 119, cell.width, 1);
    if([_memoArray count] - 1 != indexPath.row && [_memoArray count] > 1){
        separator.contents = (id)[UIImage imageWithColor:RGBA(255, 255, 255, 0.5)].CGImage;
    }else{
        separator.contents = (id)[UIImage imageWithColor:RGB(48, 179, 254)].CGImage;
    }
    [cell.layer addSublayer:separator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Action Methods
- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}
- (IBAction)editAction:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"save"]){
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
                NSMutableDictionary * dict = [NSMutableDictionary new];
                dict = [obj getDict];
                [dict removeObjectForKey:@"image"];
                [_totalDataArray addObject:dict];
            }else{
                NSMutableDictionary * dict = [NSMutableDictionary new];
                dict = [obj getDict];
                [dict removeObjectForKey:@"image"];
                [_totalDataArray removeObjectAtIndex:_index];
                [_totalDataArray insertObject:dict atIndex:_index];
            }
            [self saveData];
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


#pragma mark - UIImagePicker Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    [_editImageView setImage:img];
    [_imageBtn setAlpha:0.1];
    _imgPath = [Util saveImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}


@end

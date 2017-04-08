//
//  ContactsDetailViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 8..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ContactsDetailViewController.h"

@interface ContactsDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
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


@end

@implementation ContactsDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _totalDataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout:[NSArray arrayWithObjects:@"설정", nil]];
    [self initViews];
}

- (void)initViews
{
    AddressObj * obj = [_totalDataArray objectAtIndex:_index];
    [_detailImageView setImage:[UIImage imageWithData:[obj.imageData dataUsingEncoding:NSUTF8StringEncoding]]];
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

- (IBAction)imageSelectAction:(id)sender {
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}



@end

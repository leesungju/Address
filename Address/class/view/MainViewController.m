//
//  MainViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *proImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *memoBtn;
@property (strong, nonatomic) IBOutlet UITableView *memoTableView;
@property (strong, nonatomic) NSMutableArray * memoArray;

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memoArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GUIManager sharedInstance] removeSetting];
    [self hideMenuBtn];
    NSString * login = [[PreferenceManager sharedInstance] getPreference:@"login" defualtValue:@""];
    if(login.length <= 0){
        [[GUIManager sharedInstance] showPopup:[LoginViewController new] animation:NO complete:^(NSDictionary *dict) {
            NSString * imagePath = [UIDevice getImagePath];
            if(imagePath.length > 0){
                UIImage * image = [[UIImage alloc] initWithContentsOfFile:imagePath];
                if(image){
                    [_proImageView setImage:image];
                }
            }
            [_proImageView setCircle:[UIColor clearColor] width:1];
            [_nameLabel setText:[UIDevice getName]];
            [_phoneLabel setText:[NSStrUtils replacePhoneNumber:[UIDevice getPhoneNumber]]];
        }];
    }else{
        [[FCMManager sharedInstance] setLogin];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout];
    [[GUIManager sharedInstance] removeSetting];
    [self hideMenuBtn];
    
    NSString * imagePath = [UIDevice getImagePath];
    if(imagePath.length > 0){
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        if(image){
            [_proImageView setImage:image];
        }
    }
    [_proImageView setCircle:[UIColor clearColor] width:1];
    [_proImageView addTapGestureTarget:self action:@selector(imageAction:)];
    [_proImageView setUserInteractionEnabled:YES];
    [_nameLabel setText:[UIDevice getName]];
    [_phoneLabel setText:[NSStrUtils replacePhoneNumber:[UIDevice getPhoneNumber]]];
    _memoArray = [UIDevice getMemoArray];
    [_memoTableView setDelegate:self];
    [_memoTableView setDataSource:self];
    [_memoTableView setRadius:10];
    if(_memoArray && [_memoArray count] > 0){
        [_memoTableView setHidden:NO];
        [_memoTableView reloadData];
    }else{
        [_memoTableView setHidden:YES];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.titleLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [cell.detailLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"detail"]];
    [cell.dateLabel setText:[[_memoArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemoPopupViewController * memo = [MemoPopupViewController new];
    [memo setViewMode:kViewPopupMode_nomarl];
    [memo setIndex:(int)indexPath.row];
    [memo setDataArray:[NSMutableArray arrayWithArray:_memoArray]];
    [[GUIManager sharedInstance] showPopup:memo animation:YES complete:^(NSDictionary *dict) {
        if(dict){
            [_memoArray removeObjectAtIndex:indexPath.row];
            [_memoArray insertObject:dict atIndex:indexPath.row];
            [[PreferenceManager sharedInstance] setPreference:[Util arrayConvertJsonString:_memoArray] forKey:@"memo"];
            [_memoTableView reloadData];

        }
    }];
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_memoArray removeObjectAtIndex:indexPath.row];
    [[PreferenceManager sharedInstance] setPreference:[Util arrayConvertJsonString:_memoArray] forKey:@"memo"];
    [_memoTableView reloadData];
    if([_memoArray count] == 0)
    {
        [_memoTableView setHidden:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Action Methods

- (IBAction)memoAction:(id)sender {
    
    MemoPopupViewController * memo = [MemoPopupViewController new];
    [memo setViewMode:kViewPopupMode_add];
    [memo setIndex:0];
    [memo setDataArray:_memoArray];
    [[GUIManager sharedInstance] showPopup:memo animation:YES complete:^(NSDictionary *dict) {
        if(dict){
            [_memoArray insertObject:dict atIndex:0];
            [[PreferenceManager sharedInstance] setPreference:[Util arrayConvertJsonString:_memoArray] forKey:@"memo"];
            [_memoTableView reloadData];
            [_memoTableView setHidden:NO];
        }
    }];
}

- (void)imageAction:(id)sender
{
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
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    [_proImageView setImage:img];
    [[PreferenceManager sharedInstance] getPreference:@"imagePath" defualtValue:@""];
    [[PreferenceManager sharedInstance] setPreference:[Util saveImage:img] forKey:@"imagePath"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

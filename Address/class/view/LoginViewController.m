//
//  LoginViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 26..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) NSMutableDictionary * data;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(250, 215, 134)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_imageView setCircle:[UIColor clearColor] width:1];
    [_imageView addTapGestureTarget:self action:@selector(imageAction:)];
    [_imageView setUserInteractionEnabled:YES];
}

- (BOOL)saveData
{
    _data = [NSMutableDictionary new];
    BOOL ret = NO;
    if(_nameTextField.text.length <= 0){
        
    }else if( _phoneTextField.text.length <= 0){
        
    }else{
        NSString * name = [_nameTextField text];
        NSString * phone = [[_phoneTextField text] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if([Util checkPhone:[NSStrUtils replacePhoneNumber:phone]]){
            NSString * key = [UIDevice getDeviceId];
            [_data setObject:name forKey:@"name"];
            [_data setObject:phone forKey:@"phone"];
            MemberObj * obj = [MemberObj new];
            [obj setName:name];
            [obj setPhoneNumber:phone];
            [obj setMemberId:[UIDevice getDeviceId]];
            [obj setCreateDate:[Util fullDateConvertString:[NSDate new]]];
            [obj setImagePath:[UIDevice getImagePath]];
            
            [[PreferenceManager sharedInstance] setPreference:[obj getJsonString] forKey:@"login"];
            [[PreferenceManager sharedInstance] setPreference:[NSStrUtils urlEncoding:name] forKey:@"name"];
            [[PreferenceManager sharedInstance] setPreference:phone forKey:@"phone"];
            [[StorageManager sharedInstance] saveUser:[obj getDict] forKey:key];
            [[FCMManager sharedInstance] setLogin];
            ret = YES;
        }
    }
    return ret;
}

- (IBAction)startBtnAction:(id)sender {
    
    if([self saveData]){
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:_data];
    }
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
    [_imageView setImage:img];
    [[PreferenceManager sharedInstance] getPreference:@"imagePath" defualtValue:@""];
    [[PreferenceManager sharedInstance] setPreference:[Util saveImage:img] forKey:@"imagePath"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}
@end

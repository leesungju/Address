//
//  ContactsDetailViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 8..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ContactsDetailViewController.h"

@interface ContactsDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *imageSelectBtn;

@end

@implementation ContactsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [_imageView setImage:img];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}



@end

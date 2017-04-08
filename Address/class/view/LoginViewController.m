//
//  LoginViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 26..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) NSMutableDictionary * data;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor orangeColor]];
}

- (BOOL)saveData
{
    _data = [NSMutableDictionary new];
    BOOL ret = NO;
    if(_nameTextField.text.length <= 0){
        
    }else if( _phoneTextField.text.length <= 0){
        
    }else{
        NSString * name = [NSStrUtils urlEncoding:[_nameTextField text]];
        NSString * phone = [[_phoneTextField text] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if([self checkPhone:phone]){
            NSString * key = [phone  substringFromIndex:3];
            [_data setObject:name forKey:@"name"];
            [_data setObject:phone forKey:@"phone"];
            NSString * string = [NSString stringWithFormat:@"%@",_data];
            [[PreferenceManager sharedInstance] setPreference:string forKey:@"login"];
            [[StorageManager sharedInstance] saveUser:string forKey:key];
            ret = YES;
        }
    }
    return ret;
}

- (BOOL)checkPhone:(NSString*)phone
{
    NSString *ptn = @"(010|011|016|017|018|019)-([0-9]{3,4})-([0-9]{4})";
    NSString *str = [NSStrUtils replacePhoneNumber:phone];
    NSRange range = [str rangeOfString:ptn options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (IBAction)startBtnAction:(id)sender {
    
    if([self saveData]){
        [[StorageManager sharedInstance] loadPermissionforKey:[_data objectForKey:@"phone"] WithBlock:^(FIRDataSnapshot *snapshot) {
            NSString * permissionforKey = (NSString*)snapshot.value;
            if(![permissionforKey isKindOfClass:[NSNull class]] && permissionforKey.length > 0){
                [[PreferenceManager sharedInstance] setPreference:permissionforKey forKey:@"permission"];
            }else{
                [[PreferenceManager sharedInstance] setPreference:@"normal" forKey:@"permission"];
            }
            [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:_data];
        } withCancelBlock:^(NSError *error) {
            
        }];
        
    }
}
@end

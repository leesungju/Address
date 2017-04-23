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
            NSString * key = [UIDevice getDeviceId];
            [_data setObject:name forKey:@"name"];
            [_data setObject:phone forKey:@"phone"];
            MemberObj * obj = [MemberObj new];
            [obj setName:name];
            [obj setPhoneNumber:phone];
            [obj setMemberId:[UIDevice getDeviceId]];
            
            [[PreferenceManager sharedInstance] setPreference:[obj getJsonString] forKey:@"login"];
            [[PreferenceManager sharedInstance] setPreference:name forKey:@"name"];
            [[PreferenceManager sharedInstance] setPreference:phone forKey:@"phone"];
            [[StorageManager sharedInstance] saveUser:[obj getDict] forKey:key];
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
    
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:_data];
    [self saveData];

}
@end

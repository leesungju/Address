//
//  MainViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString * login = [[PreferenceManager sharedInstance] getPreference:@"login" defualtValue:@""];
    if(login.length <= 0){
        [[GUIManager sharedInstance] showPopup:[LoginViewController new] animation:NO complete:^(NSDictionary *dict) {
            
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout];
}


@end

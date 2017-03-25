//
//  BaseViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactsViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];

    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initView {
    _bottomTabView = [UIView new];
    [_bottomTabView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_bottomTabView];
    
    _tab1Btn = [UIButton new];
    [_tab1Btn setTitle:@"주소록" forState:UIControlStateNormal];
    [_tab1Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab1Btn.tag = 0;
    [_bottomTabView addSubview:_tab1Btn];
    
    _tab2Btn = [UIButton new];
    [_tab2Btn setTitle:@"설교" forState:UIControlStateNormal];
    [_tab2Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab2Btn.tag = 1;
    [_bottomTabView addSubview:_tab2Btn];
    
    _tab3Btn = [UIButton new];
    [_tab3Btn setTitle:@"공지사항" forState:UIControlStateNormal];
    [_tab3Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab3Btn.tag = 2;
    [_bottomTabView addSubview:_tab3Btn];
}

- (void)setViewLayout
{
    [_bottomTabView setFrame:CGRectMake(0, self.view.bottomY - 44, self.view.width, 44)];
    [_tab1Btn setFrame:CGRectMake(0, 0, _bottomTabView.width/3, _bottomTabView.height)];
    [_tab2Btn setFrame:CGRectMake(_tab1Btn.rightX, 0, _bottomTabView.width/3, _bottomTabView.height)];
    [_tab3Btn setFrame:CGRectMake(_tab2Btn.rightX, 0, _bottomTabView.width/3, _bottomTabView.height)];
}

#pragma mark - Action Methods

- (void)tabAction:(UIButton*)sender
{
    if(sender.tag == 0){
        [[GUIManager sharedInstance] moveToAddress];
    }else if(sender.tag == 1){
        [[GUIManager sharedInstance] moveToPreach];
    }else if(sender.tag == 2){
        [[GUIManager sharedInstance] moveToNotice];

    }
}

@end

//
//  BaseViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"

@interface BaseViewController () <SettingViewControllerDelegate>
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
    [_bottomTabView setBackgroundColor:[UIColor clearColor]];
   
    [self.view addSubview:_bottomTabView];
    
    _tab1Btn = [UIButton new];
    [_tab1Btn setTitle:@"주소록" forState:UIControlStateNormal];
    [_tab1Btn setRadius:5];
    [_tab1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tab1Btn setBackgroundColor:RGB(250, 254, 243)];
    
    [_tab1Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab1Btn.tag = 0;
    [_bottomTabView addSubview:_tab1Btn];
    
    _tab2Btn = [UIButton new];
    [_tab2Btn setTitle:@"그룹" forState:UIControlStateNormal];
    [_tab2Btn setRadius:5];
    [_tab2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tab2Btn setBackgroundColor:RGB(250, 254, 243)];
    
    [_tab2Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab2Btn.tag = 1;
    [_bottomTabView addSubview:_tab2Btn];
    
    _tab3Btn = [UIButton new];
    [_tab3Btn setTitle:@"공지사항" forState:UIControlStateNormal];
    [_tab3Btn setRadius:5];
    [_tab3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tab3Btn setBackgroundColor:RGB(250, 254, 243)];
    
    [_tab3Btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    _tab3Btn.tag = 2;
    [_bottomTabView addSubview:_tab3Btn];
    
    _menuBtn = [UIButton new];
    [_menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [_menuBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_menuBtn];
    
}

- (void)setViewLayout
{
    [_bottomTabView setFrame:CGRectMake(0, self.view.bottomY - 44, self.view.width, 44)];
    [_tab1Btn setFrame:CGRectMake(5, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    [_tab2Btn setFrame:CGRectMake(_tab1Btn.rightX + 10, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    [_tab3Btn setFrame:CGRectMake(_tab2Btn.rightX + 10, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    
    [_menuBtn setFrame:CGRectMake(_bottomTabView.rightX - 70, _bottomTabView.originY - 70, 40, 40)];
}

- (void)selectTabMenu:(int)index
{
    if(index == 0){
        [_tab1Btn setBackgroundColor:RGB(250, 215, 134)];
        [_tab2Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab3Btn setBackgroundColor:RGB(250, 254, 243)];
    }else if(index == 1){
        [_tab1Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab2Btn setBackgroundColor:RGB(250, 215, 134)];
        [_tab3Btn setBackgroundColor:RGB(250, 254, 243)];
    }else if(index == 2){
        [_tab1Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab2Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab3Btn setBackgroundColor:RGB(250, 215, 134)];
    }else{
        [_tab1Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab2Btn setBackgroundColor:RGB(250, 254, 243)];
        [_tab3Btn setBackgroundColor:RGB(250, 254, 243)];
    }
}
#pragma mark - Action Methods

- (void)tabAction:(UIButton*)sender
{
    [[GUIManager sharedInstance] hideSetting];
    [[GUIManager sharedInstance] backControllerWithAnimation:NO];
    if(sender.tag == 0){
        [[GUIManager sharedInstance] moveToAddress];
    }else if(sender.tag == 1){
        [[GUIManager sharedInstance] moveToPreach];
    }else if(sender.tag == 2){
        [[GUIManager sharedInstance] moveToNotice];
    }
}

- (void)hideMenu{
    [_menuBtn setHidden:NO];
}

- (void)hideMenuBtn
{
    [_menuBtn setHidden:YES];
}

- (void)menuClicked:(int)index
{
    if(index == 0){
        [[GUIManager sharedInstance] moveToHome];
    }
}

- (void)menuAction:(UIButton*)sender
{
    if(![[GUIManager sharedInstance] isShowSetting]){
        [[GUIManager sharedInstance] showSetting];
        [_menuBtn setHidden:YES];
    }
}


@end

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
@property (strong, nonatomic) SettingViewController * settingViewController;
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
    [_tab2Btn setTitle:@"설교" forState:UIControlStateNormal];
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
}

- (void)setViewLayout:(NSArray*)array
{
    [_bottomTabView setFrame:CGRectMake(0, self.view.bottomY - 44, self.view.width, 44)];
    [_tab1Btn setFrame:CGRectMake(5, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    [_tab2Btn setFrame:CGRectMake(_tab1Btn.rightX + 10, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    [_tab3Btn setFrame:CGRectMake(_tab2Btn.rightX + 10, 0, _bottomTabView.width/3 - 10, _bottomTabView.height)];
    [_settingViewController showMenuBtn];
    NSArray *titleList = array;
    NSArray *imageList = @[[UIImage imageWithColor:[UIColor redColor]], [UIImage imageWithColor:[UIColor yellowColor]], [UIImage imageWithColor:[UIColor blueColor]]];
    
    if([array count] > 0){
        _settingViewController = [[GUIManager sharedInstance] settingViewController];
        [_settingViewController setDelegate:self];
        [_settingViewController setMenuButton:titleList images:imageList];
        [_settingViewController insertButton:[[GUIManager sharedInstance] mainNavigationController].view
                                  atPosition:CGPointMake([[GUIManager sharedInstance] mainNavigationController].view.width - 60, [[GUIManager sharedInstance] mainNavigationController].view.height - 100)];
    }
    
}

- (void)hideMenu
{
    [_settingViewController dismissMenu];
    [_settingViewController hideMenuBtn];
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
    [_settingViewController dismissMenu];
    if(sender.tag == 0){
        [[GUIManager sharedInstance] moveToAddress];
    }else if(sender.tag == 1){
        [[GUIManager sharedInstance] moveToPreach];
    }else if(sender.tag == 2){
        [[GUIManager sharedInstance] moveToNotice];
    }
}

- (void)menuClicked:(int)index
{
    
}
@end

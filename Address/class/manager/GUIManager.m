//
//  GUIManager.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "GUIManager.h"
#import "MainViewController.h"
#import "ContactsViewController.h"
#import "NoticeViewController.h"
#import "GroupViewController.h"
#import "LoadingView.h"
@interface GUIManager ()

@property (strong, nonatomic) SettingViewController * settingViewController;
@property (strong, nonatomic) UIView * backgroundView;
@property (nonatomic, copy) void (^popupCompletion)(NSDictionary* dict);

@end

@implementation GUIManager

+ (GUIManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        _mainNavigationController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
        [_mainNavigationController setNavigationBarHidden:YES];
    }
    return self;
}

- (void)setSetting:(NSArray*)array delegate:(id)delegate
{
    if(_settingViewController == nil){
        _settingViewController = [[SettingViewController alloc] initWithFrame:[_mainNavigationController.view bounds]];
    }
    
    NSArray *titleList = array;
    NSArray *imageList = @[[UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]],[UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]]];
    
    if([array count] > 0){
        _settingViewController = [[GUIManager sharedInstance] settingViewController];
        [_settingViewController setDelegate:delegate];
        [_settingViewController setMenuButton:titleList images:imageList];
    }
    [_mainNavigationController.view addSubview:_settingViewController.view];
    [_mainNavigationController addChildViewController:_settingViewController];
    [_settingViewController.view setHidden:YES];
    _isShowSetting = NO;
}

- (void)showSetting
{
    _isShowSetting =YES;
    [_settingViewController.view setHidden:NO];
    [_settingViewController showMenu];
}

- (void)hideSetting
{
    _isShowSetting = NO;
    [_settingViewController.view setHidden:YES];
    [_settingViewController dismissMenu];
}

- (void)removeSetting
{
    if(_settingViewController != nil){
        [_settingViewController.view removeFromSuperview];
        _settingViewController.view = nil;
        [_settingViewController removeFromParentViewController];
        _settingViewController = nil;
    }
}

- (void)moveToHome
{
    [self removeSetting];
    [_mainNavigationController popToRootViewControllerAnimated:YES];
}

- (void)moveToAddress
{
    [self moveToController:[ContactsViewController new] animation:YES];
}

- (void)moveToPreach
{
    
    [self moveToController:[GroupViewController new] animation:YES];
}

- (void)moveToNotice
{
    
    [self moveToController:[NoticeViewController new] animation:YES];
}

- (void)moveToController:(UIViewController*)controller animation:(BOOL)isAnimation
{
    
    if(isAnimation){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        
        [_mainNavigationController.view.layer addAnimation:transition forKey:kCATransition];
    }
    [_mainNavigationController pushViewController:controller animated:NO];
}

- (void)backControllerWithAnimation:(BOOL)isAnimation
{
    [self removeSetting];
    [_mainNavigationController popViewControllerAnimated:isAnimation];
}

- (void)showPopup:(UIViewController*)controller animation:(BOOL)isAnimation complete:(PopupViewCompletionBlock)complete
{
    _popupCompletion = complete;
    [_mainNavigationController addChildViewController:controller];
    [_mainNavigationController.view addSubview:controller.view];
    [controller.view setFrame:_mainNavigationController.view.bounds];
    if(isAnimation){
        controller.view.originY = _mainNavigationController.view.bottomY;
        [UIView animateWithDuration:0.3f animations:^{
            controller.view.originY = _mainNavigationController.view.originY;
            [_mainNavigationController.view bringSubviewToFront:controller.view];
        }];
    }
}

- (void)hidePopup:(UIViewController*)controller animation:(BOOL)isAnimation completeData:(NSDictionary*)data
{
    _popupCompletion(data);
    if(isAnimation){
        controller.view.originY = _mainNavigationController.view.originY;
        [UIView animateWithDuration:0.3f animations:^{
            controller.view.originY = _mainNavigationController.view.bottomY;
        }];
    }
    [controller removeFromParentViewController];
    [controller.view removeFromSuperview];
}

- (void)showLoading
{
    if(_backgroundView == nil){
        _backgroundView = [[UIView alloc] initWithFrame:_mainNavigationController.view.bounds];
        [_backgroundView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        [LoadingView setOnView:_backgroundView];
        [_mainNavigationController.view addSubview:_backgroundView];
    }
}

- (void)hideLoading
{
    [LoadingView hideFromView:_backgroundView];
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
}

- (void)showAlert:(NSString*)message viewCon:(UIViewController*)viewCon handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:message preferredStyle:UIAlertControllerStyleAlert];
    [av addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:handler]];
    [viewCon presentViewController:av animated:YES completion:nil];
    
}

- (void)showComfirm:(NSString*)message viewCon:(UIViewController*)viewCon handler:(void (^)(UIAlertAction *action))handler cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
{
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:message preferredStyle:UIAlertControllerStyleAlert];
    [av addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:handler]];
    [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:cancelHandler]];

    [viewCon presentViewController:av animated:YES completion:nil];
    
}


@end

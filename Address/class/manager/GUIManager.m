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
#import "PreachViewController.h"

@interface GUIManager ()

@property (strong, nonatomic) ContactsViewController * contactsViewController;
@property (strong, nonatomic) PreachViewController * preachViewController;
@property (strong, nonatomic) NoticeViewController * noticeViewController;
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

- (void)moveToHome
{
    [_mainNavigationController popToRootViewControllerAnimated:YES];
    if(_contactsViewController != nil){
        [_contactsViewController.view removeFromSuperview];
        _contactsViewController.view = nil;
        [_contactsViewController removeFromParentViewController];
        _contactsViewController = nil;
    }
    if(_preachViewController !=nil){
        [_preachViewController.view removeFromSuperview];
        _preachViewController.view = nil;
        [_preachViewController removeFromParentViewController];
        _preachViewController = nil;
    }
    if(_noticeViewController !=nil){
        [_noticeViewController.view removeFromSuperview];
        _noticeViewController.view = nil;
        [_noticeViewController removeFromParentViewController];
        _noticeViewController = nil;
    }
}

- (void)moveToAddress
{
    [self removeView];
    if(_contactsViewController == nil){
        _contactsViewController = [ContactsViewController new];
        [self moveToController:_contactsViewController animation:YES];
    }
}

- (void)moveToPreach
{
    [self removeView];
    if(_preachViewController == nil){
        _preachViewController = [PreachViewController new];
        [self moveToController:_preachViewController animation:YES];
    }
}

- (void)moveToNotice
{
    [self removeView];
    if(_noticeViewController == nil){
        _noticeViewController = [NoticeViewController new];
        [self moveToController:_noticeViewController animation:YES];
    }
}

- (void)removeView
{
    [self backControllerWithAnimation:NO];
    if(_contactsViewController != nil){
        [_contactsViewController.view removeFromSuperview];
        _contactsViewController.view = nil;
        [_contactsViewController removeFromParentViewController];
        _contactsViewController = nil;
    }
    if(_preachViewController !=nil){
        [_preachViewController.view removeFromSuperview];
        _preachViewController.view = nil;
        [_preachViewController removeFromParentViewController];
        _preachViewController = nil;
    }
    if(_noticeViewController !=nil){
        [_noticeViewController.view removeFromSuperview];
        _noticeViewController.view = nil;
        [_noticeViewController removeFromParentViewController];
        _noticeViewController = nil;
    }
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

@end

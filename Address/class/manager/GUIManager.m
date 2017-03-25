//
//  GUIManager.m
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import "GUIManager.h"
#import "MainViewController.h"

@interface GUIManager ()

@property (assign, nonatomic) BOOL isLogin;
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
        _isLogin = NO;
    }
    return self;
}

- (void)moveToHome
{
    [_mainNavigationController popToRootViewControllerAnimated:NO];
}



- (void)moveToController:(UIViewController*)controller animation:(BOOL)isAnimation
{
    if(_isLogin){
        [controller.view setTag:1];
    }
    [_mainNavigationController pushViewController:controller animated:isAnimation];
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

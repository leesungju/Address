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
#import "ZoomingImageView.h"
@interface GUIManager ()

@property (strong, nonatomic) SettingViewController * settingViewController;
@property (strong, nonatomic) UIView * backgroundView;
@property (nonatomic, copy) void (^popupCompletion)(NSDictionary* dict);
@property (strong, nonatomic) ZoomingImageView * zoomingImageView;
@property (strong, nonatomic) UIButton * zoomCloseButton;

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
    NSArray *imageList = @[[UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]],[UIImage imageWithColor:[UIColor clearColor]], [UIImage imageWithColor:[UIColor clearColor]],[UIImage imageWithColor:[UIColor clearColor]]];
    
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


#pragma mark - Zooming View
- (void)setupZoomingImageView
{
    if(_zoomingImageView == nil){
        _zoomingImageView = [[ZoomingImageView alloc] initWithFrame:CGRectMake(0, 20, _mainNavigationController.view.width, _mainNavigationController.view.height - 20)];
        
        [_zoomingImageView setBackgroundColor:[UIColor blackColor]];
        [_mainNavigationController.view addSubview:_zoomingImageView];
    }
    [_zoomingImageView setHidden:YES];
    [_zoomingImageView setAlpha:0.0f];
    
    if(_zoomCloseButton == nil){
        _zoomCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 45, 60)];
        [_zoomCloseButton setImage:[UIImage imageNamed:@"close_color"] forState:UIControlStateNormal];
        [_zoomCloseButton addTarget:self action:@selector(closeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_zoomCloseButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [_zoomCloseButton.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
        [_zoomCloseButton.layer setShadowOpacity:1.0];
        [_mainNavigationController.view addSubview:_zoomCloseButton];
    }
    [_zoomCloseButton setHidden:YES];
    [_zoomCloseButton setAlpha:0.0f];
}
- (void)closeButtonPress:(id)sender
{
    [self hideFullScreenZoomingView:YES];
}

- (void)showFullScreenZoomingViewWithImage:(UIImage *)image animate:(BOOL)animate
{
    [self setupZoomingImageView];
    [self.zoomingImageView setImage:image];
    [UIView animateWithDuration:(animate)?0.3:0.0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.zoomingImageView setHidden:NO];
                         [self.zoomingImageView setAlpha:1.0f];
                         [self.zoomCloseButton setHidden:NO];
                         [self.zoomCloseButton setAlpha:1.0f];
                     }
                     completion:nil];
}

- (void)hideFullScreenZoomingView:(BOOL)animate
{
    [UIView animateWithDuration:(animate)?0.3:0.0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.zoomingImageView setAlpha:0.0f];
                         [self.zoomCloseButton setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.zoomingImageView setHidden:YES];
                         [self.zoomingImageView removeFromSuperview];
                         self.zoomingImageView = nil;
                         [self.zoomCloseButton setHidden:YES];
                         [self.zoomCloseButton removeFromSuperview];
                         self.zoomCloseButton = nil;
                     }];
}

@end

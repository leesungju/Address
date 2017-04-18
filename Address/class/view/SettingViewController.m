//
//  SettingViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 7..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize isOpen = _isOpen;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [self.view setFrame:frame];
        _isOpen = NO;
    }
    return self;
}

- (void)setMenuButton:(NSArray*)title images:(NSArray*)images
{
    if(_buttonList != nil && [_buttonList count] >0){
        [_buttonList removeAllObjects];
        [_backgroundMenuView removeFromSuperview];
        _backgroundMenuView = nil;
    }
    
    if(_backgroundMenuView == nil){
        _backgroundMenuView = [UIView new];
    }
    if(_otherView == nil){
        _otherView = [UIView new];
    }
    
    _buttonList = [NSMutableArray new];
    
    for (int i = 0; i< [title count] ; i++){
        UIImage *image = [images objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 50 + (80 * i), 50, 50);
        button.tag = i;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_buttonList addObject:button];
        [_backgroundMenuView addSubview:button];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    _otherView.frame = [self.view bounds];
    _otherView.height = _otherView.height - 44;
    [_otherView setUserInteractionEnabled:YES];
    [_otherView addGestureRecognizer:singleTap];
    [_otherView setBackgroundColor:[UIColor clearColor]];
    [_otherView setHidden:YES];
    [self.view addSubview:_otherView];
    
    _backgroundMenuView.frame = CGRectMake(self.view.frame.size.width, 0, 90, self.view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [self.view addSubview:_backgroundMenuView];
}

- (void)removeView
{
    [_otherView removeFromSuperview];
    [_backgroundMenuView removeFromSuperview];
}

#pragma mark -
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    if (_isOpen)
    {
        _isOpen = NO;
        [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = YES;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuClicked:)])
        [self.delegate menuClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        [_otherView setHidden:YES];
    } completion:^(BOOL finished) {
        [[GUIManager sharedInstance] hideSetting];
        if ([self.delegate respondsToSelector:@selector(hideMenu)])
            [self.delegate hideMenu];
        
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            
        }];
    });
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.2f
                                  delay:0.2f
                 usingSpringWithDamping:.2f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                                 [_otherView setHidden:NO];
                             }];
        });
    }
}

@end

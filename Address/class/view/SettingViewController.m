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

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;


- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, 40, 40);
        [_menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        _menuColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setMenuButton:(NSArray*)title images:(NSArray*)images
{
    if(_buttonList != nil && [_buttonList count] >0){
        [_buttonList removeAllObjects];
        [_backgroundMenuView removeFromSuperview];
        _backgroundMenuView = nil;
        _backgroundMenuView = [UIView new];
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
        [_buttonList addObject:button];
    }
}

- (void)insertButton:(UIView*)view atPosition:(CGPoint)position
{
   
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    
    for (UIButton *button in _buttonList)
    {
        [_backgroundMenuView addSubview:button];
    }
    _otherView.frame = [view bounds];
    _otherView.height = _otherView.height - 44;
    [_otherView setUserInteractionEnabled:YES];
    [_otherView addGestureRecognizer:singleTap];
    [_otherView setBackgroundColor:[UIColor clearColor]];
    [_otherView setHidden:YES];
    [view addSubview:_otherView];
    
    _menuButton.frame = CGRectMake(position.x, position.y, _menuButton.frame.size.width, _menuButton.frame.size.height);
    [view addSubview:_menuButton];
    [view bringSubviewToFront:_menuButton];

    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    [view addSubview:_backgroundMenuView];
    
    
}

- (void)hideMenuBtn
{
    [_menuButton setHidden:YES];
}
- (void)showMenuBtn
{
    [_menuButton setHidden:NO];
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
        _isOpen = !_isOpen;
        [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
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
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        [_otherView setHidden:YES];
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _menuButton.alpha = 0.0f;
            _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            [_otherView setHidden:NO];
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
                             }];
        });
    }
}

@end

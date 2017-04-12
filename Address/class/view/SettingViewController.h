//
//  SettingViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 7..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingViewControllerDelegate <NSObject>

- (void)menuClicked:(int)index;
@optional
- (void)hideMenu;

@end

@interface SettingViewController : UIViewController
{
    UIView              *_backgroundMenuView;
    UIView              *_otherView;
    NSMutableArray      *_buttonList;
}


@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<SettingViewControllerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setMenuButton:(NSArray*)title images:(NSArray*)images;
- (void)showMenu;
- (void)dismissMenu;
- (void)removeView;
@end


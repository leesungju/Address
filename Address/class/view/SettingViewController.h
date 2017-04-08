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

@end

@interface SettingViewController : NSObject
{
    UIView              *_backgroundMenuView;
    UIView              *_otherView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}


@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<SettingViewControllerDelegate> delegate;

- (void)setMenuButton:(NSArray*)title images:(NSArray*)images;
- (void)insertButton:(UIView*)view atPosition:(CGPoint)position;
- (void)dismissMenu;
- (void)hideMenuBtn;
- (void)showMenuBtn;

@end


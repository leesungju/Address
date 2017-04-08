//
//  BaseViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIView * bottomTabView;
@property (strong, nonatomic) UIButton * tab1Btn;
@property (strong, nonatomic) UIButton * tab2Btn;
@property (strong, nonatomic) UIButton * tab3Btn;


- (void)setViewLayout:(NSArray*)array;
- (void)hideMenu;
- (void)menuClicked:(int)index;
@end

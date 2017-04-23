//
//  LoadingView.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView *)setOnView:(UIView *)view;
+ (BOOL)hideFromView:(UIView *)view;
+ (LoadingView *)getView: (UIView *)view;

@end

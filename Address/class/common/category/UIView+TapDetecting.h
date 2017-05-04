//
//  UIView+TapDetecting.h
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectingViewDelegate;

@interface UIView (TapDetecting)
@property (nonatomic, weak) id<TapDetectingViewDelegate> tapDelegate;
@end

@protocol TapDetectingViewDelegate <NSObject>
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
@end

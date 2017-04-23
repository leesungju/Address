//
//  UIView+Common.h
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

@interface UIView (SJCommon)

@property (nonatomic, assign) CGPoint bottomRightPoint;
@property (nonatomic, assign) float_t bottomY;
@property (nonatomic, assign) float_t rightX;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) float originX;
@property (nonatomic, assign) float originY;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

- (void)showBorder:(UIColor*)borderColor width:(float)borderWidth;
- (void)setCircle:(UIColor *)borderColor width:(float)borderWidth;
- (void)setRadius:(float)borderWidth;
- (void)addTapGestureTarget:(id)target action:(SEL)action;
- (void)bringToFront;
@end

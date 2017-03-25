//
//  UIView+Common.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (AECommon)

@dynamic bottomRightPoint;
@dynamic bottomY;
@dynamic rightX;
@dynamic origin;
@dynamic size;
@dynamic originX;
@dynamic originY;
@dynamic width;
@dynamic height;

- (CGPoint) origin{
    return self.frame.origin;
}

- (void) setOrigin:(CGPoint)aPoint{
    self.frame = CGRectMake(aPoint.x, aPoint.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize) size{
    return self.frame.size;
}

- (void) setSize:(CGSize)aSize{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, aSize.width, aSize.height);
}

- (float) originX {
    return self.frame.origin.x;
}

- (void) setOriginX:(float)aX{
    CGRect r = self.frame;
    r.origin.x = aX;
    self.frame = r;
}

- (float) originY {
    return self.frame.origin.y;
}

- (void) setOriginY:(float)aY{
    CGRect r = self.frame;
    r.origin.y = aY;
    self.frame = r;
}

- (float) height{
    return self.frame.size.height;
}

- (void) setHeight:(float)aHeight{
    CGRect r = self.frame;
    r.size.height = aHeight;
    self.frame = r;
}

- (float) width{
    return self.frame.size.width;
}

- (void) setWidth:(float)aWidth{
    CGRect r = self.frame;
    r.size.width = aWidth;
    self.frame = r;
}

- (void) setBottomRightPoint:(CGPoint)aPoint{
    [self setOrigin:CGPointMake(aPoint.x - self.frame.size.width, aPoint.y - self.frame.size.height)];
}

- (CGPoint) bottomRightPoint {
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

- (float_t) bottomY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottomY:(float_t)aBottomY{
    CGRect r = self.frame;
    r.origin.y = aBottomY - self.frame.size.height;
    self.frame = r;
}

- (float_t) rightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRightX:(float_t)aRightX{
    CGRect r = self.frame;
    r.origin.x = aRightX - self.frame.size.width;
    self.frame = r;
}

- (void)showBorder:(UIColor *)borderColor width:(float)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setCircle:(UIColor *)borderColor width:(float)borderWidth
{
    [self.layer setCornerRadius:self.width/2];
    [self.layer setMasksToBounds:YES];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setRadius:(float)borderWidth
{
    [self.layer setCornerRadius:borderWidth];
    [self.layer setMasksToBounds:YES];

}

- (void)addTapGestureTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

@end


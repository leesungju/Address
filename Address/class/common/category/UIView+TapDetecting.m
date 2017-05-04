//
//  UIView+TapDetecting.m
//  SlanderService
//
//  Created by JoAmS on 2015. 6. 1..
//  Copyright (c) 2015년 JoAmS. All rights reserved.
//

#import "UIView+TapDetecting.h"
#import <objc/runtime.h>

static char TapDetectingViewDelegate;

@implementation UIView (TapDetecting)
@dynamic tapDelegate;

- (void)setTapDelegate:(id<TapDetectingViewDelegate>)tapDelegate
{
    [self willChangeValueForKey:@"TapDetectingViewDelegate"];
    objc_setAssociatedObject(self, &TapDetectingViewDelegate,
                             tapDelegate,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TapDetectingViewDelegate"];
}

- (id<TapDetectingViewDelegate>)tapDelegate
{
    return objc_getAssociatedObject(self, &TapDetectingViewDelegate);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tapDelegate == nil){
        [[self nextResponder] touchesEnded:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch
{
    if ([self.tapDelegate respondsToSelector:@selector(view:singleTapDetected:)]){
        [self.tapDelegate view:self singleTapDetected:touch];
    }
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([self.tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)]){
        [self.tapDelegate view:self doubleTapDetected:touch];
    }
}
@end

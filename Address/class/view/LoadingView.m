//
//  LoadingView.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) BOOL isSpinning;
@end

@implementation LoadingView

+ (LoadingView *)setOnView:(UIView *)view
{
    LoadingView *hud = [[LoadingView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 50.0f, 50.0f)];

    [hud start];
    [view addSubview:hud];
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    CGPoint center = CGPointMake(width/2, height/2);
    hud.center = center;
    return hud;
}

+ (BOOL)hideFromView:(UIView *)view
{
    LoadingView *hud = [LoadingView getView:view];
    [hud stop];
    if (hud) {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (LoadingView *)getView: (UIView *)view
{
    LoadingView *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [LoadingView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (LoadingView *)aView;
        }
    }
    return hud;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _backgroundLayer.frame = self.bounds;
}

- (void)initView
{
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    self.backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = [UIColor redColor].CGColor;
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = fmaxf(self.frame.size.width * 0.035, 1.f);
    [self.layer addSublayer:_backgroundLayer];
}

- (void)drawBackgroundCircle:(BOOL) partial {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 Degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - fmaxf(self.frame.size.width * 0.035, 1.f))/2;
    
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = fmaxf(self.frame.size.width * 0.035, 1.f);

    if (partial) {
        endAngle = (1.8f * (float)M_PI) + startAngle;
    }
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _backgroundLayer.path = processBackgroundPath.CGPath;
}

#pragma mark - Spin
- (void)start {
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop{
    [self drawBackgroundCircle:NO];
    [_backgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}

@end

//
//  PreachViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "PreachViewController.h"

@interface PreachViewController ()

@end

@implementation PreachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout:[NSArray arrayWithObjects:@"설정", nil]];
    [self selectTabMenu:1];
    
}


#pragma mark - action medhods



@end

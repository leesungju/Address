//
//  NoticeViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setViewLayout:[NSArray arrayWithObjects:@"설정", nil]];
    [self selectTabMenu:2];
}


#pragma mark - action medhods



@end


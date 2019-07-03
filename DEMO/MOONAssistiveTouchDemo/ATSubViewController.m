//
//  ATSubViewController.m
//  MOONAssistiveTouchDemo
//
//  Created by 徐一丁 on 2019/7/3.
//  Copyright © 2019 月之暗面. All rights reserved.
//

#import "ATSubViewController.h"

@interface ATSubViewController ()

@end

@implementation ATSubViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"浮窗子页面";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

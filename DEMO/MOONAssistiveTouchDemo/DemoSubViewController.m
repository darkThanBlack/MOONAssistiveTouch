//
//  DemoSubViewController.m
//  MOONAssistiveTouchDemo
//
//  Created by 徐一丁 on 2019/7/3.
//  Copyright © 2019 月之暗面. All rights reserved.
//

#import "DemoSubViewController.h"

@interface DemoSubViewController ()

@end

@implementation DemoSubViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"业务子页面";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

@end


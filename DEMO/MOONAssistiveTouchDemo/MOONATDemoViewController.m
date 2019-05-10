//
//  MOONATDemoViewController.m
//  MOONAssistiveTouchDemo
//
//  Created by 徐一丁 on 2019/5/10.
//  Copyright © 2019 月之暗面. All rights reserved.
//

#import "MOONATDemoViewController.h"

#import "MOONAssistiveTouch/MOONATCore.h"

@interface MOONATDemoViewController ()

@end

@implementation MOONATDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[MOONATCore core]configMenuItemActions:[MOONATCore demoActions]];
    [[MOONATCore core]start];
}

@end

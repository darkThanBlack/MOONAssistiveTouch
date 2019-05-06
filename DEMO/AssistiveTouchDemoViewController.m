//
//  AssistiveTouchDemoViewController.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "AssistiveTouchDemoViewController.h"

#import "MOONAssistiveTouch/MOONATCore.h"

@interface AssistiveTouchDemoViewController ()

@end

@implementation AssistiveTouchDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MOONATCore core]configMenuItemActions:nil];
    [[MOONATCore core] start];
}

@end

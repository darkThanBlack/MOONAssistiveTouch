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
    
    [[MOONATCore core]configMenuItemActions:nil];
    [[MOONATCore core]start];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

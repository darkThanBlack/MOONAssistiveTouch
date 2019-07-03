//
//  MOONATDemoViewController.m
//  MOONAssistiveTouchDemo
//
//  Created by 徐一丁 on 2019/5/10.
//  Copyright © 2019 月之暗面. All rights reserved.
//

#import "MOONATDemoViewController.h"

#import "MOONAssistiveTouch/MOONATCore.h"

#import "DemoSubViewController.h"
#import "ATSubViewController.h"

@interface MOONATDemoViewController ()

@end

@implementation MOONATDemoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"业务页面";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[MOONATCore core]configMenuItemActions:[self configActions]];
    [[MOONATCore core]start];
}

- (NSArray<MOONATMenuItemAction *> *)configActions
{
    NSMutableArray<MOONATMenuItemAction *> *demoArray = [NSMutableArray arrayWithArray:[MOONATCore demoActions]];
    
    MOONATMenuItemAction *action_demoSub = [MOONATMenuItemAction actionWithTitle:@"业务页面" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        DemoSubViewController *demoSubVC = [[DemoSubViewController alloc]init];
        [self.navigationController pushViewController:demoSubVC animated:YES];
    }];
    [demoArray addObject:action_demoSub];

    MOONATMenuItemAction *action_ATSub = [MOONATMenuItemAction actionWithTitle:@"浮窗页面" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        ATSubViewController *atSubVC = [[ATSubViewController alloc]init];
        [[MOONATCore core].navigationController pushViewController:atSubVC animated:YES];
    }];
    [demoArray addObject:action_ATSub];
    
    return demoArray;
}

@end

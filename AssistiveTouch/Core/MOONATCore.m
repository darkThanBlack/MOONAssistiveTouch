//
//  MOONATCore.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATCore.h"

#import "MOONATWindow.h"
#import "MOONATRootViewController.h"

static MOONATCore *core_ = nil;

@interface MOONATCore ()

@property (nonatomic, strong) MOONATWindow *window;
@property (nonatomic, strong, readwrite) UINavigationController *navigationController;
@property (nonatomic, strong) MOONATRootViewController *rootVC;

@end

@implementation MOONATCore

#pragma mark Life Cycle

+ (MOONATCore *)core
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core_ = [[super alloc]init];
        
    });
    return core_;
}

#pragma mark Getter

- (UINavigationController *)navigationController
{
    if (!_navigationController) {
        _navigationController = [[UINavigationController alloc]initWithRootViewController:self.rootVC];
    }
    return _navigationController;
}

- (MOONATRootViewController *)rootVC
{
    if (!_rootVC) {
        _rootVC = [[MOONATRootViewController alloc]init];
    }
    return _rootVC;
}

- (MOONATWindow *)window
{
    if (!_window) {
        _window = [[MOONATWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor clearColor];
        _window.windowLevel = CGFLOAT_MAX;
        _window.isAccessibilityElement = YES;
        _window.accessibilityIdentifier = @"MOONATT_window";
        
        _window.rootViewController = self.navigationController;
        _window.noResponseView = self.rootVC.view;
    }
    return _window;
}

#pragma mark - Interface

/**
 配置菜单按钮与对应事件
 
 示例：构建一个按钮
 
 ```
 
     MOONATMenuItemAction *action_demo = [MOONATMenuItemAction actionWithTitle:@"demo" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
         [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeClose params:nil];
     }];
 
 ```

 @param actions actions description
 */
- (void)configMenuItemActions:(NSArray<MOONATMenuItemAction *> *)actions
{
    if (actions && actions.count) {
        self.rootVC.actions = actions;
    } else {
        self.rootVC.actions = [MOONATCore demoActions];
    }
}

- (void)start
{
    self.window.hidden = NO;
}

- (void)stop
{
    self.window.hidden = YES;
}

#pragma mark - Demo

+ (NSArray<MOONATMenuItemAction *> *)demoActions
{
    MOONATMenuItemAction *action_skin = [MOONATMenuItemAction actionWithTitle:@"换肤" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeSkin params:nil];
    }];
    
    MOONATMenuItemAction *action_sub = [MOONATMenuItemAction actionWithTitle:@"嵌套菜单" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_sub_0 = [MOONATMenuItemAction actionWithTitle:@"三级菜单" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_sub_1 = [MOONATMenuItemAction actionWithTitle:@"1" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_sub_2 = [MOONATMenuItemAction actionWithTitle:@"2" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];

    MOONATMenuItemAction *action_sub_3 = [MOONATMenuItemAction actionWithTitle:@"3" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];

    MOONATMenuItemAction *action_sub_4 = [MOONATMenuItemAction actionWithTitle:@"4" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];

    MOONATMenuItemAction *action_sub_5 = [MOONATMenuItemAction actionWithTitle:@"none" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];

    action_sub_0.subActions = @[action_sub_4, action_sub_5];
    action_sub.subActions = @[action_sub_0, action_sub_1, action_sub_2, action_sub_3];
    
    MOONATMenuItemAction *action_delay = [MOONATMenuItemAction actionWithTitle:@"延时变淡" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeDelayFade params:nil];
    }];
    
    MOONATMenuItemAction *action_absorb = [MOONATMenuItemAction actionWithTitle:@"吸附模式" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeAbsorb params:nil];
    }];
    
    MOONATMenuItemAction *action_appearaence = [MOONATMenuItemAction actionWithTitle:@"特效设置" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    action_appearaence.subActions = @[action_delay, action_absorb];
    
    MOONATMenuItemAction *action_scan = [MOONATMenuItemAction actionWithTitle:@"扫描" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_toast = [MOONATMenuItemAction actionWithTitle:@"上方提示" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeShowToast params:@{@"text": @"容器上方提示\n测试地址：https://github.com/darkThanBlack/MOONAssistiveTouch"}];
    }];
    
    return @[action_skin, action_appearaence, action_sub, action_scan, action_toast];
}

@end

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
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.rootVC];
        _window.rootViewController = nav;
        
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
    
    MOONATMenuItemAction *action_sub_0 = [MOONATMenuItemAction actionWithTitle:@"0" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
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
    
    MOONATMenuItemAction *action_service = [MOONATMenuItemAction actionWithTitle:@"切换地址" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_service_0 = [MOONATMenuItemAction actionWithTitle:@"dev" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_service_1 = [MOONATMenuItemAction actionWithTitle:@"qa" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    MOONATMenuItemAction *action_service_2 = [MOONATMenuItemAction actionWithTitle:@"qb" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    MOONATMenuItemAction *action_service_3 = [MOONATMenuItemAction actionWithTitle:@"qc" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    MOONATMenuItemAction *action_service_4 = [MOONATMenuItemAction actionWithTitle:@"qd" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    MOONATMenuItemAction *action_service_5 = [MOONATMenuItemAction actionWithTitle:@"qe" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    action_service.subActions = @[action_service_0, action_service_1, action_service_2, action_service_3, action_service_4, action_service_5];
    
    MOONATMenuItemAction *action_scan = [MOONATMenuItemAction actionWithTitle:@"扫描" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    MOONATMenuItemAction *action_old = [MOONATMenuItemAction actionWithTitle:@"旧版" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
        
    }];
    
    return @[action_skin, action_appearaence, action_sub, action_service, action_scan, action_old];
}

@end

//
//  MOONATMenuItemAction.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/25.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATMenuItemAction.h"

@interface MOONATMenuItemAction ()

///AssistiveTouch动作,由contentView实现
@property (nonatomic, copy, nullable) MOONAssistiveTouchActionBlock assistiveTouchBlock;

///menu动作,由menuView实现
@property (nonatomic, copy, nullable) MOONAssistiveTouchMenuActionBlock menuBlock;

@end

@implementation MOONATMenuItemAction

/**
 便捷构造方法
 
 其他属性默认置空，由具体的菜单页面处理
 
 @param title 按钮文字
 @param itemBlock 按钮触发事件
 @return MOONATMenuItemAction
 */
+ (MOONATMenuItemAction *)actionWithTitle:(NSString *)title itemBlock:(MOONATMenuItemActionBlock)itemBlock
{
    return [MOONATMenuItemAction actionWithTitle:title localImageName:nil skin:nil subActions:nil itemBlock:itemBlock];
}

/**
 便捷构造方法
 
 @param title 按钮文字
 @param localImageName 按钮本地图片名
 @param skin 按钮皮肤
 @param subActions 下一级菜单按钮列表
 @param itemBlock 按钮事件
 @return MOONATMenuItemAction
 */
+ (MOONATMenuItemAction *)actionWithTitle:(NSString *)title localImageName:(NSString * _Nullable )localImageName skin:(NSDictionary * _Nullable)skin subActions:(NSArray<MOONATMenuItemAction *> * _Nullable)subActions itemBlock:(MOONATMenuItemActionBlock _Nullable)itemBlock
{
    MOONATMenuItemAction *action = [[MOONATMenuItemAction alloc]init];
    action.title = title;
    action.localImageName = localImageName;
    action.skin = skin;
    action.subActions = subActions;
    action.itemBlock = itemBlock;
    return action;
}

#pragma mark -


/**
 触发浮窗页面事件
 
 存在一种场景：菜单按钮事件触发时，需要对浮窗页面进行修改（如颜色，图片，样式等），而根据设计，后期可能会有多种浮窗样式
 
 这里使用 MOONAssistiveTouchActionMode 约定了浮窗页面需要执行的动作，使用 params 传递可能需要的约定参数
 
 每个 Action 持有的动作事件根据浮窗页面的具体实现可能会有所不同
 
 示例，构建一个 action，触发时通知浮窗页面收起菜单：
 
 ```
 
 MOONATMenuItemAction *action_close = [MOONATMenuItemAction actionWithTitle:@"关闭菜单" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
 [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeClose params:nil];
 }];
 
 ```
 
 @param actionMode AssistiveTouch动作
 @param params 约定的自定义参数
 */
- (void)triggerAssistiveTouchAction:(MOONAssistiveTouchActionMode)actionMode params:(NSDictionary * __nullable)params
{
    if (self.assistiveTouchBlock) {
        self.assistiveTouchBlock(actionMode, params);
    }
}


/**
 触发菜单页面事件

 存在一种场景：菜单按钮事件触发时，需要对菜单页面进行修改（如背景色，大小，动画等），而根据设计，后期可能会有多种菜单样式
 
 这里使用 MOONAssistiveTouchMenuActionMode 约定了菜单页面需要执行的动作，使用 params 传递可能需要的约定参数
 
 每个 Action 持有的动作事件根据菜单页面的具体实现可能会有所不同
 
 示例，构建一个 action，触发时通知菜单页面展示约定的提示信息：
 
 ```
 
 MOONATMenuItemAction *action_toast = [MOONATMenuItemAction actionWithTitle:@"提示" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
 [action triggerAssistiveTouchMenuAction:MOONAssistiveTouchMenuActionModeShowToast params:@{@"text": @"提示测试"}];
 }];
 
 ```
 
 @param menuMode menu动作
 @param params 约定的自定义参数
 */
- (void)triggerAssistiveTouchMenuAction:(MOONAssistiveTouchMenuActionMode)menuMode params:(NSDictionary *)params
{
    if (self.menuBlock) {
        self.menuBlock(menuMode, params);
    }
}

#pragma mark -


/**
 绑定浮窗页面事件
 
 存在一种场景：菜单按钮事件触发时，浮窗页面允许它来改变自身的属性或者形态
 
 根据具体场景，在管理类传递值的时候需要遍历 actions 列表，并在 block 中实现具体动作
 
 block 实现由 action 持有，所以允许不同的 action 对应不同的动作实现
 
 @param assistiveTouchBlock block
 */
- (void)bindAssistiveTouchActionBlock:(MOONAssistiveTouchActionBlock)assistiveTouchBlock
{
    self.assistiveTouchBlock = assistiveTouchBlock;
}

/**
 绑定菜单页面事件
 
 存在一种场景：菜单按钮事件触发时，菜单页面允许它来改变自身的属性或者形态
 
 根据具体场景，在菜单解析具体 action 的时候需要遍历 actions 列表，并在 block 中实现具体动作
 
 block 实现由 action 持有，所以允许不同的 action 对应不同的动作实现
 
 @param menuBlock block
 */
- (void)bindMenuActionBlock:(MOONAssistiveTouchMenuActionBlock)menuBlock
{
    self.menuBlock = menuBlock;
}

@end

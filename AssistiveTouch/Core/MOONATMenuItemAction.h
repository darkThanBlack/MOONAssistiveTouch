//
//  MOONATMenuItemAction.h
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/25.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MOONATMenuItemAction;

/** AssistiveTouch行为模式 */
typedef NS_ENUM(NSUInteger, MOONAssistiveTouchActionMode) {
    /** 关闭菜单 */
    MOONAssistiveTouchActionModeClose,
    
    /** 换肤 */
    MOONAssistiveTouchActionModeChangeSkin,
    
    /** 吸附模式 */
    MOONAssistiveTouchActionModeChangeAbsorb,
    
    /** 延时变淡模式 */
    MOONAssistiveTouchActionModeChangeDelayFade
};

/** 内容菜单行为模式 */
typedef NS_ENUM(NSUInteger, MOONAssistiveTouchMenuActionMode) {
    /** 展示提示文字 */
    MOONAssistiveTouchMenuActionModeShowToast,
    
    /** 暂无 */
    MOONAssistiveTouchMenuActionModeOther
};

typedef void(^MOONATMenuItemActionBlock)(MOONATMenuItemAction *action);
typedef void(^MOONAssistiveTouchActionBlock)(MOONAssistiveTouchActionMode actionMode,  NSDictionary * _Nullable params);
typedef void(^MOONAssistiveTouchMenuActionBlock)(MOONAssistiveTouchMenuActionMode menuMode, NSDictionary *params);

///菜单按钮通用模型类
@interface MOONATMenuItemAction : NSObject

/**
 按钮文字
 */
@property (nonatomic, strong, nonnull) NSString *title;

/**
 按钮事件
 
 一般情况下菜单按钮按下时触发回调，在block内实现具体的业务操作
 
 如果同时需要对浮窗或者菜单页面实现控制（如触发后需要收起菜单），在 block 内调用 triggerAssistiveTouchAction:params 和 triggerAssistiveTouchMenuAction:params: 系列方法，通知对应页面执行相应动作
 
 示例1，构建一个 action，触发时通知浮窗页面收起菜单：
 
 ```
 
 MOONATMenuItemAction *action_close = [MOONATMenuItemAction actionWithTitle:@"关闭菜单" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
     [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeClose params:nil];
 }];
 
 ```
 
 示例2，构建一个 action，触发时通知菜单页面展示约定的提示信息：
 
 ```

 MOONATMenuItemAction *action_close = [MOONATMenuItemAction actionWithTitle:@"提示" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
     [action triggerAssistiveTouchMenuAction:MOONAssistiveTouchMenuActionModeShowToast params:@{@"text": @"提示测试"}];
  }];
 
 ```
 
 */
@property (nonatomic, copy, nullable) MOONATMenuItemActionBlock itemBlock;

/**
 下一级菜单
 
 如果需要子菜单，给这个属性赋值，子菜单的具体展开与关闭应由菜单页面内部处理，不需要在 itemBlock 内自行实现
 
 当前action被触发时，无论是否有子菜单，也会触发 itemBlock
 */
@property (nonatomic, strong, nullable) NSArray<MOONATMenuItemAction *> *subActions;

/**
 本地按钮图片名
 
 目前只考虑了最简单的情况，解析交给具体的菜单页面
 */
@property (nonatomic, strong, nullable) NSString *localImageName;

/**
 按钮皮肤
 
 包含一组用于外观控制的参数，具体的 key-value 根据具体的菜单页面不同而不同
 
 一般情况下菜单页面需要处理为空的默认情况，也用来实现换肤功能
 */
@property (nonatomic, strong, nullable) NSDictionary *skin;

#pragma mark - inistall

//便捷构造方法
+ (MOONATMenuItemAction *)actionWithTitle:(NSString *)title itemBlock:(MOONATMenuItemActionBlock _Nullable)itemBlock;

//便捷构造方法
+ (MOONATMenuItemAction *)actionWithTitle:(NSString *)title localImageName:(NSString * _Nullable )localImageName skin:(NSDictionary * _Nullable)skin subActions:(NSArray<MOONATMenuItemAction *> * _Nullable)subActions itemBlock:(MOONATMenuItemActionBlock _Nullable)itemBlock;

#pragma mark - user trigger

//触发浮窗页面事件,由业务代码调用
- (void)triggerAssistiveTouchAction:(MOONAssistiveTouchActionMode)actionMode params:(NSDictionary * __nullable)params;

//触发菜单页面事件，由业务代码调用
- (void)triggerAssistiveTouchMenuAction:(MOONAssistiveTouchMenuActionMode)menuMode params:(NSDictionary *)params;

#pragma mark - custom menu view action

//绑定菜单页面事件，由具体的菜单页面调用
- (void)bindMenuActionBlock:(MOONAssistiveTouchMenuActionBlock)menuBlock;

// 绑定浮窗页面事件,由具体的浮窗页面调用
- (void)bindAssistiveTouchActionBlock:(MOONAssistiveTouchActionBlock)assistiveTouchBlock;

@end

NS_ASSUME_NONNULL_END

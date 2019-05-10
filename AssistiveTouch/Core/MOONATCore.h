//
//  MOONATCore.h
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MOONATMenuItemAction.h"

NS_ASSUME_NONNULL_BEGIN

///单例，持有 浮窗 window 保证不被释放
@interface MOONATCore : NSObject

+ (MOONATCore *)core;

//默认菜单，Demo展示用
+ (NSArray<MOONATMenuItemAction *> *)demoActions;

//配置菜单按钮与对应事件,传demoActions查看示例
- (void)configMenuItemActions:(NSArray<MOONATMenuItemAction *> *)actions;

//显示浮窗
- (void)start;

//隐藏浮窗
- (void)stop;

@end

NS_ASSUME_NONNULL_END

//
//  MOONATSystemMenuView.h
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/22.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MOONATMenuItemAction;

NS_ASSUME_NONNULL_BEGIN

///菜单视图-仿系统风格
@interface MOONATSystemMenuView : UIView

//配置主菜单的皮肤和菜单按钮，每次调用都会重新移除并创建所有的菜单按钮
- (void)configWithSkin:(NSDictionary * __nullable)menuSkin actions:(NSArray<MOONATMenuItemAction *> *)actions;

//配置菜单的打开状态与动画
- (void)configOpenStateWithFrame:(CGRect)frame animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

//配置菜单的关闭状态与动画
- (void)configCloseStateWithFrame:(CGRect)frame animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

//直接移除所有子菜单
- (void)closeSubMenus;

@end


NS_ASSUME_NONNULL_END

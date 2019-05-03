//
//  MOONATContentView.h
//  MOONCodes
//
//  Created by 月之暗面 on 2019/4/21.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MOONATAbsorbMode) {
    MOONATAbsorbModeNone = 0,  //无特效
    MOONATAbsorbModeSystem,  //仿系统AssistiveTouch吸附
    MOONATAbsorbModeEdge  //仅靠近边缘时吸附
};

@class MOONATContentView;

typedef NSArray<UIView *> *_Nullable(^MOONATConfigSubViewsBlock)(MOONATContentView *contentView);
typedef void(^MOONATConfigSubViewCloseStateBlock)(MOONATContentView *contentView);
typedef void(^MOONATConfigSubViewOpenStateBlock)(MOONATContentView *contentView);

///浮窗，承载所有菜单
@interface MOONATContentView : UIView

///吸附模式
@property (nonatomic, assign) MOONATAbsorbMode absorbMode;

///延时变淡模式
@property (nonatomic, assign) BOOL delayFade;

///干！
- (void)start;

- (void)configFrameWithOpenState:(CGRect)openFrame closeState:(CGRect)closeFrame;

///自行更新菜单开启/关闭状态
- (void)updateContentViewState;

///配置所有需要添加的子视图，与subViews栈顺序一致
- (void)configSubViews:(MOONATConfigSubViewsBlock)block;

///配置子视图在菜单关闭时的状态，调用start方法时会先调用一次
- (void)configSubViewCloseState:(MOONATConfigSubViewCloseStateBlock)block;

///配置子视图在菜单开启时的状态
- (void)configSubViewOpenState:(MOONATConfigSubViewOpenStateBlock)block;

@end

NS_ASSUME_NONNULL_END

//
//  MOONATWindow.h
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///浮窗 window，覆盖在所有 window 上，用于拦截浮窗事件
@interface MOONATWindow : UIWindow

/**
 重写 hitTest 事件，这个 view 的所有事件不会被响应
 
 一般被用做 assistiveTouch 的背景 view ,  assistiveTouch 视图加在这个 view 的上面
 */
@property (nonatomic, strong) UIView *noResponseView;

@end

NS_ASSUME_NONNULL_END

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

- (void)configMenuItemActions:(NSArray<MOONATMenuItemAction *> *)actions;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END

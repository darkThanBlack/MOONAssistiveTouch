//
//  MOONATRootViewController.h
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOONATMenuItemAction;

NS_ASSUME_NONNULL_BEGIN

///浮窗根控制器
@interface MOONATRootViewController : UIViewController

@property (nonatomic, strong) NSArray<MOONATMenuItemAction *> *actions;

@end

NS_ASSUME_NONNULL_END

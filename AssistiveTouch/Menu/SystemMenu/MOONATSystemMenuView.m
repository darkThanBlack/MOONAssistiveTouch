//
//  MOONATSystemMenuView.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/22.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATSystemMenuView.h"
#import "MOONATMenuHelper.h"
#import "MOONATMenuItemAction.h"

#ifndef j2h
#define j2h(x) (M_PI * (x) / 180.0)  //角度与弧度转换
#endif

@class MOONATSystemItem;

typedef void(^MOONATSystemItemActionBlock)(MOONATSystemItem *item);

///菜单按钮
@interface MOONATSystemItem : UIView

///按钮图片
@property (nonatomic, strong) UIImageView *imageView;

///按钮文字
@property (nonatomic, strong) UILabel *titleLabel;

///按钮事件
@property (nonatomic, copy, nullable) MOONATSystemItemActionBlock tapActionBlock;

@end

@implementation MOONATSystemItem

#pragma mark Getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

#pragma mark Skin

- (void)bindSkin:(NSDictionary *)skin
{
    UIColor *textColor = [skin objectForKey:@"textColor"];
    if (textColor) {
        self.titleLabel.textColor = textColor;
    }
}

#pragma mark Life Cycle

- (instancetype)init
{
    if (self = [super init]) {
        [self loadMOONATSystemItems_];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadMOONATSystemItems_];
    }
    return self;
}

#pragma mark View

- (void)loadMOONATSystemItems_
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemsEvent:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
}

///FIXME:不应该在内部调整自身高度,不是好写法，待改进
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((self.frame.size.width - self.imageView.frame.size.width)/2.0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.titleLabel.frame = CGRectMake(0, self.imageView.frame.size.height + 8.0, self.frame.size.width, self.titleLabel.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.imageView.frame.size.height + 8.0 + self.titleLabel.frame.size.height);
}

- (void)itemsEvent:(UITapGestureRecognizer *)gesture
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
}

@end

@interface MOONATSystemItem (Action)

- (void)bindAction:(MOONATMenuItemAction *)action subMenuAction:(void (^)(MOONATMenuItemAction *action))handler;

@end

///菜单按钮事件处理
@implementation MOONATSystemItem (Action)

/**
 绑定按钮的Action事件
 
 解析 action 属性到按钮页面，并计算当前按钮布局与大小，最后根据 subActions 是否为空决定是否一并触发打开下级菜单事件
 
 @param action 通用 action
 @param handler 菜单视图回调，用于让当前菜单打开下级菜单
 */
- (void)bindAction:(MOONATMenuItemAction *)action subMenuAction:(void (^)(MOONATMenuItemAction *action))handler
{
    [self.imageView setImage:[MOONATMenuHelper imageNamed:action.localImageName]];
    self.titleLabel.text = action.title;
    
    if (action.skin) {
        [self bindSkin:action.skin];
    }
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    [self layoutIfNeeded];  //重设自身大小
    
    self.tapActionBlock = ^(MOONATSystemItem *item) {
        //如果有下级菜单，触发打开下级菜单回调
        if (action.subActions && action.subActions.count) {
            if (handler) {
                handler(action);
            }
        }
        //一并触发当前action回调
        if (action.itemBlock) {
            action.itemBlock(action);
        }
    };
}

@end

#pragma mark -

@interface MOONATSystemMenuView ()

/**
 通用事件列表，核心属性
 
 每次触发 setter 都会重新移除并创建所有的菜单按钮，并绑定所有必要的属性和回调，按钮大小主要由按钮自身根据 action 属性布局决定
 
 不会控制按钮位置，需要后续调用 config 系列方法控制按钮位置布局和相应动画
 
 */
@property (nonatomic, strong) NSArray<MOONATMenuItemAction *> *actions;

///菜单视图自己的皮肤
@property (nonatomic, strong, nullable) NSDictionary *menuSkin;

///AssistiveTouch可拖动状态时展示的图片
@property (nonatomic, strong) UIImageView *imageView;

///毛玻璃视图层，换肤时会重新创建
@property (nonatomic, strong) UIVisualEffectView *visualView;

///在视图中心展示提示信息
@property (nonatomic, strong) UILabel *toastLabel;

///关闭子视图按钮
@property (nonatomic, strong) UIButton *backButton;



///菜单按钮视图数组
@property (nonatomic, strong) NSArray<MOONATSystemItem *> *itemArray;

///默认的菜单皮肤
@property (nonatomic, strong) NSDictionary *defaultMenuSkin;

///是否是子菜单
@property (nonatomic, assign) BOOL isSubMenu;

@end

@implementation MOONATSystemMenuView

#pragma mark Getter

- (NSDictionary *)defaultMenuSkin
{
    if (!_defaultMenuSkin) {
        _defaultMenuSkin = @{
                             @"effect": [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight],
                             @"imageType": @(0),
                             @"textColor": [UIColor blackColor]
                             };
    }
    return _defaultMenuSkin;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor clearColor];
        [_imageView setImage:[MOONATMenuHelper imageNamed:@"moonShadow"]];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 18.0;
    }
    return _imageView;
}

- (UILabel *)toastLabel
{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc]init];
        _toastLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.alpha = 0.0;
        _toastLabel.textColor = [UIColor blackColor];
    }
    return _toastLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitle:@"返回" forState:UIControlStateHighlighted];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightHeavy];
        
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.borderWidth = 1.0;
        
        [_backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark Setter

- (void)setMenuSkin:(NSDictionary *)menuSkin
{
    _menuSkin = menuSkin;
    
    if (!_menuSkin) {
        _menuSkin = self.defaultMenuSkin;
    }
    
    [self.visualView removeFromSuperview];
    UIVisualEffect *effect = _menuSkin[@"effect"];
    self.visualView = [[UIVisualEffectView alloc]initWithEffect:effect];
    self.visualView.hidden = YES;
    self.visualView.layer.masksToBounds = YES;
    self.visualView.layer.cornerRadius = 18.0;
    [self insertSubview:self.visualView aboveSubview:self.imageView];
    
    self.toastLabel.textColor = _menuSkin[@"textColor"];
    
    [self.backButton setTitleColor:_menuSkin[@"textColor"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:_menuSkin[@"textColor"] forState:UIControlStateHighlighted];
    self.backButton.layer.borderColor = [_menuSkin[@"textColor"] CGColor];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MOONATSystemMenuView class]]) {
            MOONATSystemMenuView *subMenu = (MOONATSystemMenuView *)subView;
            subMenu.menuSkin = self.menuSkin;
        }
    }
}

- (void)setActions:(NSArray<MOONATMenuItemAction *> *)actions
{
    _actions = actions;
    
    [self.itemArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < _actions.count; i++) {
        MOONATSystemItem *item = [[MOONATSystemItem alloc]initWithFrame:CGRectMake(0, 0, 64, 200)];  //frame会被自身重写
        item.backgroundColor = [UIColor clearColor];
        
        MOONATMenuItemAction *action = _actions[i];
        
        [action bindMenuActionBlock:^(MOONAssistiveTouchMenuActionMode menuMode, NSDictionary * _Nonnull params) {
            if (menuMode == MOONAssistiveTouchMenuActionModeShowToast) {
                NSString *text = [params objectForKey:@"text"];
                [self showToast:text];
            }
        }];

        [item bindAction:action subMenuAction:^(MOONATMenuItemAction *action) {
            //设置打开下级菜单事件
            MOONATSystemMenuView *subMenu = [[MOONATSystemMenuView alloc]init];
            subMenu.hidden = YES;
            [subMenu configWithSkin:self.menuSkin actions:action.subActions isSubMenu:YES];
            [self addSubview:subMenu];
            
            //动画
            [self configCloseStateWithFrame:self.frame animated:YES completion:^(BOOL finished) {
                subMenu.hidden = NO;
                [subMenu configOpenStateWithFrame:self.bounds animated:YES completion:nil];
            }];
        }];
        
        [array addObject:item];
        [self addSubview:item];
    }
    
    self.itemArray = [NSArray arrayWithArray:array];
}

#pragma mark Interface
 
/**
 配置主菜单的皮肤和菜单按钮
 
 每次调用都会触发 actions 的 setter 方法，重新移除并创建所有的菜单按钮，并绑定所有必要的属性和回调，按钮大小主要由按钮自身根据 action 属性布局决定
 
 不会控制按钮位置，需要后续调用 config 系列方法控制按钮位置布局和相应动画
 
 可以重复调用以实现换肤效果
 
 @param menuSkin 菜单皮肤，传空会给一个默认皮肤
 @param actions 菜单按钮 model array
 */
- (void)configWithSkin:(NSDictionary * __nullable)menuSkin actions:(NSArray<MOONATMenuItemAction *> *)actions
{
    [self configWithSkin:menuSkin actions:actions isSubMenu:NO];
}

/**
 配置菜单的皮肤和菜单按钮

 @param menuSkin 菜单皮肤
 @param actions model array
 @param isSubMenu 是否是子菜单
 */
- (void)configWithSkin:(NSDictionary * __nullable)menuSkin actions:(NSArray<MOONATMenuItemAction *> *)actions isSubMenu:(BOOL)isSubMenu
{
    self.menuSkin = menuSkin?menuSkin:self.defaultMenuSkin;
    self.actions = actions;
    self.isSubMenu = isSubMenu;
    
    [self layoutIfNeeded];
}

/**
 配置菜单的打开状态与动画

 @param frame 会先将菜单设置为指定的frame，再对子视图执行动画
 @param animated 是否执行动画效果
 @param completion 动画完成后回调
 */
- (void)configOpenStateWithFrame:(CGRect)frame animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion
{
    self.frame = frame;
    
    self.visualView.hidden = NO;
    self.imageView.hidden = YES;
    self.toastLabel.hidden = NO;
    self.backButton.hidden = !self.isSubMenu;
    
    //打开时，只负责从中心散开的打开动画
    for (UIView *view in self.itemArray) {
        view.hidden = NO;
        view.center = self.center;
        view.alpha = 0.0;
    }
    [UIView animateWithDuration:animated?0.3:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self loadRoundItems:self.itemArray forViewFrame:self.bounds itemOffset:360.0f/self.itemArray.count roundGap:8.0f];
        for (UIView *view in self.itemArray) {
            view.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

/**
 配置菜单的关闭状态与动画

 @param frame 会先将菜单设置为指定的frame，再对子视图执行动画
 @param animated 是否执行动画效果
 @param completion 动画完成后回调
 */
- (void)configCloseStateWithFrame:(CGRect)frame animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion
{
    self.frame = frame;
    
    //关闭时，负责向内部收缩的动画
    for (UIView *view in self.itemArray) {
        view.alpha = 1.0;
    }
    [UIView animateWithDuration:animated?0.3:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIView *view in self.itemArray) {
            view.center = self.center;
            view.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        //收缩完成后再显示按钮
        self.visualView.hidden = YES;
        self.imageView.hidden = NO;
        self.toastLabel.hidden = YES;
        self.backButton.hidden = !self.isSubMenu;
        for (UIView *view in self.itemArray) {
            view.hidden = YES;
        }
        if (completion) {
            completion(finished);
        }
    }];
}

///当外部事件导致主菜单需要被直接关闭时,可以调用这个方法直接移除所有子菜单
- (void)closeSubMenus
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MOONATSystemMenuView class]]) {
            MOONATSystemMenuView *subMenu = (MOONATSystemMenuView *)subView;
            [subMenu removeFromSuperview];
        }
    }
}

/**
 当需要在当前菜单展示提示信息时，可以调用这个方法来在视图中心进行展示
 
 如果当前菜单是子菜单，显示时会暂时隐藏返回按钮
 
 @param text 提示文字
 @bug 连续点击未隐藏返回按钮
 
 */
- (void)showToast:(NSString *)text
{
    self.toastLabel.text = text;
    [self.toastLabel sizeToFit];
    
    self.backButton.hidden = YES;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.toastLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:3.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.toastLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.isSubMenu) {
                self.backButton.hidden = NO;
            }
        }];
    }];
}

#pragma mark Life Cycle

- (instancetype)init
{
    if (self = [super init]) {
        [self loadSystemMenuViews_];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSystemMenuViews_];
    }
    return self;
}

- (void)loadSystemMenuViews_
{
    [self addSubview:self.imageView];
    [self addSubview:self.toastLabel];
    [self addSubview:self.backButton];
    
    self.menuSkin = self.defaultMenuSkin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.visualView.frame = self.imageView.bounds;
    self.toastLabel.center = self.imageView.center;
    
    self.backButton.frame = CGRectMake(0, 0, 50, 50);
    self.backButton.center = self.imageView.center;
    self.backButton.layer.cornerRadius = self.backButton.frame.size.width / 2.0;
}

#pragma mark Event

- (void)backButtonEvent:(UIButton *)button
{
    [self configCloseStateWithFrame:self.frame animated:YES completion:^(BOOL finished) {
        if ([self.superview isKindOfClass:[MOONATSystemMenuView class]]) {
            MOONATSystemMenuView *superMenu = (MOONATSystemMenuView *)self.superview;
            [superMenu configOpenStateWithFrame:superMenu.frame animated:YES completion:nil];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark Private

/**
 *  用于实现大圆内切一组小圆的效果.
 *
 *  基础思路:item的center恰好均在外层View的某个同心圆上,故根据给定的角度即可计算出每个item对应的center.
 *
 *  @param itemArray   传入items,本方法会计算出新的中心点后去更改item的center属性
 *  @param basicViewFrame   item将要添加到的viewFrame
 *  @param angleOffset item之间的夹角
 *  @param roundGap    item边界与basicView边界的距离
 *  @bug 个数偏少或元素长方形时，位置不尽如人意
 */
- (void)loadRoundItems:(NSArray *)itemArray forViewFrame:(CGRect)basicViewFrame itemOffset:(CGFloat)angleOffset roundGap:(CGFloat)roundGap
{
    for (int i = 0; i < itemArray.count; i++)
    {
        UIView *itemView = itemArray[i];
        CGFloat itemWidth = itemView.frame.size.width;
        CGFloat itemHeight = itemView.frame.size.height;
        
        //取较长的一边作圆
        CGFloat itemRadius = (itemWidth > itemHeight?itemWidth:itemHeight) / 2;
        
        CGFloat radiusOutside = basicViewFrame.size.width / 2;  //外层圆半径
        CGFloat radiusInside = radiusOutside - roundGap - itemRadius;  //内层圆半径
        
        CGFloat angleStart = (180.0 - angleOffset * (itemArray.count - 1)) / 2;  //起始角度
        
        /**
         *  注意iOS坐标系与数学坐标系不同;从起始角度开始依次排列item
         */
        CGFloat itemAngle = -90.0 + angleStart + angleOffset * i;
        CGFloat itemOriginX = radiusInside * sin(j2h(itemAngle));
        CGFloat itemOriginY = radiusInside * cos(j2h(itemAngle));
        
        /**
         *  保证内圆圆心与外圆圆心重合
         */
        itemOriginX += radiusOutside;
        itemOriginY += radiusOutside;
        
        itemView.center = CGPointMake(itemOriginX, itemOriginY);
    }
}

@end

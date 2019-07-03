
//
//  MOONATRootViewController.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATRootViewController.h"

#import "MOONATContentView.h"

#import "MOONATMenuItemAction.h"

#import "MOONATSystemMenuView.h"

NSString * const kMOONATSystemMenuSkinKey = @"kMOONATSystemMenuSkinKey";

@interface MOONATRootViewController ()

///用于填充空白背景区域，触发关闭菜单事件
@property (nonatomic, strong) UIView *menuCloseView;

///容器上方提示
@property (nonatomic, strong) UILabel *aboveHintLabel;

///菜单容器
@property (nonatomic, strong) MOONATContentView *contentView;

///自定义菜单
@property (nonatomic, strong) MOONATSystemMenuView *menuView_0;

///记录吸附模式
@property (nonatomic, assign) NSInteger absorbIndex;

///皮肤属性源数组
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *skinArray;

///当前皮肤
@property (nonatomic, strong) NSDictionary *skin;

///默认图片数组
@property (nonatomic, strong) NSMutableArray<NSString *> *imageNameArray;

@end

@implementation MOONATRootViewController

#pragma mark Getter

- (MOONATSystemMenuView *)menuView_0
{
    if (!_menuView_0) {
        _menuView_0 = [[MOONATSystemMenuView alloc]init];
        _menuView_0.backgroundColor = [UIColor clearColor];
//        _menuView_0.isAccessibilityElement = YES;
        _menuView_0.accessibilityIdentifier = @"MOONATT_rootvc_menuview_0";
    }
    return _menuView_0;
}

- (UIView *)menuCloseView
{
    if (!_menuCloseView) {
        _menuCloseView = [[UIView alloc]init];
        _menuCloseView.backgroundColor = [UIColor clearColor];
//        _menuCloseView.isAccessibilityElement = YES;
        _menuCloseView.accessibilityIdentifier = @"MOONATT_rootvc_menucloseview";
        
        _menuCloseView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assistiveTouchedEvent:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_menuCloseView addGestureRecognizer:singleTap];
    }
    return _menuCloseView;
}

- (UILabel *)aboveHintLabel
{
    if (!_aboveHintLabel) {
        _aboveHintLabel = [[UILabel alloc]init];
        
        _aboveHintLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _aboveHintLabel.text = @"上方提示";
        _aboveHintLabel.textColor = [UIColor whiteColor];
        _aboveHintLabel.font = [UIFont systemFontOfSize:12];
        _aboveHintLabel.numberOfLines = 0;
        
        _aboveHintLabel.layer.masksToBounds = YES;
        _aboveHintLabel.layer.cornerRadius = 3.0;
        
        _aboveHintLabel.userInteractionEnabled = YES;  //阻拦事件
    }
    return _aboveHintLabel;
}

- (MOONATContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[MOONATContentView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
//        _contentView.isAccessibilityElement = YES;
        _contentView.accessibilityIdentifier = @"MOONATT_rootvc_contentview";

        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assistiveTouchedEvent:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_contentView addGestureRecognizer:singleTap];
    }
    return _contentView;
}

- (NSMutableArray<NSString *> *)imageNameArray
{
    if (!_imageNameArray) {
        NSDictionary *skin = self.skin?self.skin:nil;
        NSInteger imageType = skin?[[skin objectForKey:@"imageType"] integerValue]:0;
        NSString *imageBasicName = [NSString stringWithFormat:@"MOON_AT_item_%ld_", (long)imageType];
        
        _imageNameArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < 20; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%ld", imageBasicName, (long)i];
            [_imageNameArray addObject:imageName];
        }
    }
    return _imageNameArray;
}

#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.isAccessibilityElement = YES;
    self.view.accessibilityIdentifier = @"MOONATT_rootvc";
    
    //用于空白区域关闭菜单
    self.menuCloseView.hidden = YES;
    self.menuCloseView.frame = self.view.bounds;
    [self.view addSubview:self.menuCloseView];
    
    //用于容器上方提示
    [self.view addSubview:self.aboveHintLabel];

    //optional: 重写默认配置
    if (![self.contentView hasResumableConfig]) {
        MOONATContentConfig *config = [[MOONATContentConfig alloc]init];
        
        config.closeFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.0) - 32.5, ([UIScreen mainScreen].bounds.size.height / 2.0) - 32.5, 65.0, 65.0);
        config.openFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.0) - 150.0, ([UIScreen mainScreen].bounds.size.height / 2.0) - 150.0, 300.0, 300.0);
        config.absorbMode = MOONATAbsorbModeSystem;
        config.delayFadeMode = YES;
        config.fadeAlpha = 0.3;
        config.fadeDelayTime = 4.0;
        
        self.contentView.config = config;
    }
    
    [self.view addSubview:self.contentView];
    
    [self.contentView configSubViews:^NSArray<UIView *> * _Nullable(MOONATContentView * _Nonnull contentView) {
        return @[self.menuView_0];
    }];
    
    [self.contentView configSubViewCloseState:^(MOONATContentView * _Nonnull contentView) {
        self.menuCloseView.hidden = YES;
        
        [self.menuView_0 closeSubMenus];  //先关闭子菜单，防止动画出错
        [self.menuView_0 updateToCloseStateWithFrame:contentView.bounds animated:NO completion:nil];
        
        [self updateAboveToast:@"" show:NO animated:NO];
    }];
    
    [self.contentView configSubViewOpenState:^(MOONATContentView * _Nonnull contentView) {
        self.menuCloseView.hidden = NO;
        
        [self.menuView_0 updateToOpenStateWithFrame:contentView.bounds animated:NO completion:nil];
    }];
    
    [self.contentView start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark View

- (void)setActions:(NSArray<MOONATMenuItemAction *> *)actions
{
    _actions = actions;
    
    [self configDataWithActions:_actions];
    
    [self.menuView_0 configWithSkin:self.skin actions:_actions];
}

//检查 actions 的空属性并补充相应的皮肤，图片等
- (void)configDataWithActions:(NSArray<MOONATMenuItemAction *> *)actions
{
    for (NSInteger i = 0; i < actions.count; i++) {
        MOONATMenuItemAction *action = actions[i];
        if (action.subActions) {
            [self configDataWithActions:action.subActions];  //递归设置子菜单样式
        }
        
        //为空时设置默认属性
        if (!action.title) {
            action.title = [NSString stringWithFormat:@"%ld", (long)i];
        }
        if (!action.localImageName) {
            action.localImageName = self.imageNameArray[i];
        }
        if (!action.skin) {
            action.skin = self.skin;
        }
        
        //绑定触发事件
        [action bindAssistiveTouchActionBlock:^(MOONAssistiveTouchActionMode actionMode, NSDictionary * _Nonnull params) {
            switch (actionMode) {
                case MOONAssistiveTouchActionModeClose:
                {
                    [self.contentView updateContentViewState];
                }
                    break;
                case MOONAssistiveTouchActionModeChangeSkin:
                {
                    //FIXME:换皮只能在第一层主菜单进行,子菜单触发布局事件设计时尚未考虑到,应全部交予action进行,突破第一层限制
                    [self changeSkin];
                    
                    self.actions = self.actions;
                    //重设为打开状态
                    [self.menuView_0 updateToOpenStateWithFrame:self.menuView_0.frame animated:NO completion:nil];
                }
                    break;
                case MOONAssistiveTouchActionModeChangeAbsorb:
                {
                    [self.contentView updateAbsorbMode];
                    NSString *hint = nil;
                    switch (self.contentView.config.absorbMode)
                    {
                        case MOONATAbsorbModeSystem:
                            hint = @"System";
                            break;
                        case MOONATAbsorbModeEdge:
                            hint = @"Edge";
                            break;
                        case MOONATAbsorbModeNone:
                            hint = @"None";
                            break;
                    }
                    [action triggerAssistiveTouchMenuAction:MOONAssistiveTouchMenuActionModeShowToast params:@{@"text": hint}];
                }
                    break;
                case MOONAssistiveTouchActionModeChangeDelayFade:
                {
                    [self.contentView updateDelayFadeMode];
                    [action triggerAssistiveTouchMenuAction:MOONAssistiveTouchMenuActionModeShowToast params:@{@"text": self.contentView.config.delayFadeMode?@"已开启":@"已关闭"}];
                }
                    break;
                case MOONAssistiveTouchActionModeShowToast:
                {
                    [self updateAboveToast:[params objectForKey:@"text"] show:YES animated:YES];
                }
                    break;
            }
        }];
    }
}

#pragma mark Event

- (void)assistiveTouchedEvent:(UITapGestureRecognizer *)gesture
{
    [self.contentView updateContentViewState];
}

- (void)updateAboveToast:(NSString *)text show:(BOOL)show animated:(BOOL)animated
{
    self.aboveHintLabel.text = text;
    [self.aboveHintLabel sizeToFit];
    
    CGRect referFrame = self.contentView.config.openFrame;
    self.aboveHintLabel.frame = CGRectMake(referFrame.origin.x, referFrame.origin.y, referFrame.size.width, self.aboveHintLabel.frame.size.height);
    
    if (show) {
        self.aboveHintLabel.hidden = NO;
        [UIView animateWithDuration:animated?0.3:0.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.aboveHintLabel.frame = CGRectMake(referFrame.origin.x, referFrame.origin.y - self.aboveHintLabel.frame.size.height - 8.0, referFrame.size.width, self.aboveHintLabel.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:animated?0.3:0.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.aboveHintLabel.frame = CGRectMake(referFrame.origin.x, referFrame.origin.y, referFrame.size.width, self.aboveHintLabel.frame.size.height);
        } completion:^(BOOL finished) {
            self.aboveHintLabel.hidden = YES;
        }];
    }
}

#pragma mark - Skin

- (void)changeSkin
{
    NSInteger nowIndex = 0;
    if ([self.skinArray containsObject:self.skin]) {
        nowIndex = [self.skinArray indexOfObject:self.skin];
        if ((nowIndex + 1) < self.skinArray.count) {
            nowIndex = nowIndex + 1;
        } else {
            nowIndex = 0;
        }
    } else {
        nowIndex = 0;
    }
    self.skin = self.skinArray[nowIndex];
    
    NSDictionary *skin = self.skin?self.skin:nil;
    NSInteger imageType = skin?[[skin objectForKey:@"imageType"] integerValue]:0;
    NSString *imageBasicName = [NSString stringWithFormat:@"MOON_AT_item_%ld_", (long)imageType];
    
    [self.imageNameArray removeAllObjects];
    for (NSInteger i = 0; i < 20; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%ld", imageBasicName, (long)i];
        [self.imageNameArray addObject:imageName];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@(nowIndex) forKey:kMOONATSystemMenuSkinKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self resetActionsSkin:self.actions];
}

//初始化配置成功后已经有值，故无法触发新皮肤设置,需要先置空属性
- (void)resetActionsSkin:(NSArray<MOONATMenuItemAction *> *)actions
{
    for (MOONATMenuItemAction *action in actions) {
        action.localImageName = nil;
        action.skin = nil;
        if (action.subActions) {
            [self resetActionsSkin:action.subActions];  //递归置空子菜单属性
        }
    }
}

- (NSMutableArray<NSDictionary *> *)skinArray
{
    if (!_skinArray) {
        _skinArray = [[NSMutableArray alloc]init];
        
        NSArray<NSArray *> *skinOriginalArray = [[NSArray alloc]init];
        
        NSArray *effectArray = @[@"effect",
                                 [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight],
                                 [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]
                                 ];
        NSArray *imagesArray = @[@"imageType",
                                 @(0),
                                 @(1)
                                 ];
        NSArray *textColorArray = @[@"textColor",
                                    [UIColor blackColor],
                                    [UIColor whiteColor]
                                    ];
        
        skinOriginalArray = @[effectArray, imagesArray, textColorArray];
        //从给定的材料中依次排列出所有组合
        [self configSkinArray:_skinArray fromOriginalArray:skinOriginalArray index:0 skin:[NSMutableDictionary new]];
    }
    return _skinArray;
}

- (NSDictionary *)skin
{
    if (!_skin) {
        NSInteger index = [[[NSUserDefaults standardUserDefaults]objectForKey:kMOONATSystemMenuSkinKey] integerValue];
        if (ABS(index) < self.skinArray.count) {
            _skin = self.skinArray[index];
        } else {
            _skin = [self.skinArray firstObject];
        }
    }
    return _skin;
}

- (void)configSkinArray:(NSMutableArray *)skinArray fromOriginalArray:(NSArray<NSArray *> *)originalArray index:(NSInteger)index skin:(NSMutableDictionary *)skin
{
    for (NSInteger i = 0; i < originalArray.count; i++) {
        if (i == index) {
            NSArray *subArray = originalArray[i];
            for (NSInteger j = 1; j < subArray.count; j++) {
                NSString *key = subArray[0];  //约定subArray的第一个元素为skin的key
                id value = subArray[j];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setDictionary:skin];  //开辟新的内存空间
                [dict setValue:value forKey:key];
                if (i == (originalArray.count - 1)) {
                    [skinArray addObject:dict];  //遍历完成
                } else if (i < (originalArray.count - 1)) {
                    [self configSkinArray:skinArray fromOriginalArray:originalArray index:(i + 1) skin:dict];  //递归解析下一个元素
                }
            }
        }
    }
}

@end

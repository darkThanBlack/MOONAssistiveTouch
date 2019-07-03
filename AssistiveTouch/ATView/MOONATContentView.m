//
//  MOONATContentView.m
//  MOONCodes
//
//  Created by 月之暗面 on 2019/4/21.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATContentView.h"

@implementation MOONATContentConfig

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGRect:self.closeFrame forKey:@"closeFrame"];
    [aCoder encodeCGRect:self.openFrame forKey:@"openFrame"];
    [aCoder encodeInteger:self.absorbMode forKey:@"absorbMode"];
    [aCoder encodeBool:self.delayFadeMode forKey:@"delayFadeMode"];
    [aCoder encodeFloat:self.fadeAlpha forKey:@"fadeAlpha"];
    [aCoder encodeFloat:self.fadeDelayTime forKey:@"fadeDelayTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.closeFrame = [aDecoder decodeCGRectForKey:@"closeFrame"];
        self.openFrame = [aDecoder decodeCGRectForKey:@"openFrame"];
        self.absorbMode = [aDecoder decodeIntegerForKey:@"absorbMode"];
        self.delayFadeMode = [aDecoder decodeBoolForKey:@"delayFadeMode"];
        self.fadeAlpha = [aDecoder decodeFloatForKey:@"fadeAlpha"];
        self.fadeDelayTime = [aDecoder decodeFloatForKey:@"fadeDelayTime"];
    }
    return self;
}

@end

#pragma mark -

NSString * const kMOONATResumableConfigKey = @"kMOONATResumableConfigKey";

@interface MOONATContentView ()

///记录拖动起始位置
@property (nonatomic, assign) CGPoint oldDragPoint;

///当前是否为展示菜单状态
@property (nonatomic, assign, readonly) BOOL isOpen;

///延时变淡
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat delay;

@property (nonatomic, strong) MOONATConfigSubViewCloseStateBlock closeBlock;
@property (nonatomic, strong) MOONATConfigSubViewOpenStateBlock openBlock;

@end

@implementation MOONATContentView

#pragma mark -

- (MOONATContentConfig *)config
{
    if (!_config) {
        NSData *tmpData = [[NSUserDefaults standardUserDefaults]objectForKey:kMOONATResumableConfigKey];
        MOONATContentConfig *tmp = tmpData?[NSKeyedUnarchiver unarchiveObjectWithData:tmpData]:nil;
        if (tmp) {
            _config = tmp;
        } else {
            _config = [[MOONATContentConfig alloc]init];
            
            _config.closeFrame = CGRectMake(100, 100, 65.0, 65.0);
            _config.openFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.0) - 150.0, ([UIScreen mainScreen].bounds.size.height / 2.0) - 150.0, 300.0, 300.0);
            _config.absorbMode = MOONATAbsorbModeSystem;
            _config.delayFadeMode = YES;
            _config.fadeAlpha = 0.3;
            _config.fadeDelayTime = 4.0;
        }
    }
    return _config;
}

#pragma mark - Interface

- (BOOL)hasResumableConfig
{
    NSData *tmpData = [[NSUserDefaults standardUserDefaults]objectForKey:kMOONATResumableConfigKey];
    MOONATContentConfig *tmp = tmpData?[NSKeyedUnarchiver unarchiveObjectWithData:tmpData]:nil;
    return tmp?YES:NO;
}

- (void)clearLocalConfig
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMOONATResumableConfigKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)start
{
    self.frame = self.config.closeFrame;
    
    self.delay = self.config.fadeDelayTime;
    self.closeBlock(self);
    [self layoutIfNeeded];
}

- (BOOL)isOpen
{
    if (CGSizeEqualToSize(self.frame.size, self.config.openFrame.size)) {
        return YES;
    }
    return NO;
}

- (void)updateContentViewState
{
    CGRect updateFrame = CGRectZero;
    
    if (self.isOpen) {
        updateFrame = self.config.closeFrame;
    } else {
        self.config.closeFrame = self.frame;  //记录打开菜单前的位置
        updateFrame = self.config.openFrame;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = updateFrame;
        if (self.isOpen) {
            self.openBlock(self);
        } else {
            self.closeBlock(self);
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ((!self.isOpen) && self.config.delayFadeMode) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(contentDelayFadeHandle:) userInfo:nil repeats:YES];
        }
    }];
}

- (void)updateAbsorbMode
{
    if (self.config.absorbMode == MOONATAbsorbModeNone) {
        self.config.absorbMode = 0;
    } else {
        self.config.absorbMode += 1;
    }
}

- (void)updateDelayFadeMode
{
    self.config.delayFadeMode = !self.config.delayFadeMode;
}

- (void)configSubViews:(MOONATConfigSubViewsBlock)block
{
    if (block) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSArray<UIView *> *subViews = block(self);
        for (NSInteger i = 0; i < subViews.count; i++) {
            [self addSubview:subViews[i]];
        }
    }
}

- (void)configSubViewCloseState:(MOONATConfigSubViewCloseStateBlock)block
{
    if (block) {
        self.closeBlock = block;
    }
}

- (void)configSubViewOpenState:(MOONATConfigSubViewOpenStateBlock)block
{
    if (block) {
        self.openBlock = block;
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.oldDragPoint = [touch locationInView:self];
    
    [self.timer invalidate];
    self.delay = self.config.fadeDelayTime;
    self.alpha = 1.0;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isOpen) {
        UITouch *touch = [touches anyObject];
        CGPoint newPoint = [touch locationInView:self];
        
        CGRect tempFrame = self.frame;
        tempFrame.origin.x += newPoint.x - self.oldDragPoint.x;
        tempFrame.origin.y += newPoint.y - self.oldDragPoint.y;
        self.frame = tempFrame;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isOpen) {
        CGRect newFrame = [self frameHelperInside:self.frame barrierFrame:[UIScreen mainScreen].bounds];
        
        if (self.config.absorbMode == MOONATAbsorbModeSystem) {
            newFrame = [self frameHelperAbsorbSystem:newFrame barrierFrame:[UIScreen mainScreen].bounds];
        }
        if (self.config.absorbMode == MOONATAbsorbModeEdge) {
            newFrame = [self frameHelperAbsorbEdge:newFrame barrierFrame:[UIScreen mainScreen].bounds];
        }
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            self.config.closeFrame = self.frame;
            
            NSData *tmpData = [NSKeyedArchiver archivedDataWithRootObject:self.config];
            [[NSUserDefaults standardUserDefaults]setObject:tmpData forKey:kMOONATResumableConfigKey];
            [[NSUserDefaults standardUserDefaults]synchronize];

            if (self.config.delayFadeMode) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(contentDelayFadeHandle:) userInfo:nil repeats:YES];
            }
        }];
    }
}

#pragma mark - Handle

- (void)contentDelayFadeHandle:(NSTimer *)timer
{
    self.delay = (self.delay > 0)?(self.delay - 1):0;
    if (self.delay == 0) {
        [timer invalidate];  //timer有可能被多次创建
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = self.config.fadeAlpha;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Frame Helper

///超出区域拉回
- (CGRect)frameHelperInside:(CGRect)userFrame barrierFrame:(CGRect)barrierFrame
{
    CGRect newFrame = userFrame;
    
    if (newFrame.origin.x < 0) {
        newFrame.origin.x = 0;
    }
    if (newFrame.origin.x > (barrierFrame.size.width - newFrame.size.width)) {
        newFrame.origin.x = barrierFrame.size.width - newFrame.size.width;
    }
    
    if (newFrame.origin.y < 0) {
        newFrame.origin.y = 0;
    }
    if (newFrame.origin.y > (barrierFrame.size.height - newFrame.size.height)) {
        newFrame.origin.y = barrierFrame.size.height - newFrame.size.height;
    }
    
    return newFrame;
}

///系统模式贴边
- (CGRect)frameHelperAbsorbSystem:(CGRect)userFrame barrierFrame:(CGRect)barrierFrame
{
    CGRect newFrame = userFrame;
    
    CGFloat midWidth = newFrame.size.width / 2.0;
    CGFloat midHeight = newFrame.size.height / 2.0;
    
    BOOL needChange = YES;
    if (newFrame.origin.y < midHeight) {
        newFrame.origin.y = 0;
        needChange = NO;
    }
    
    if (newFrame.origin.y > ((barrierFrame.size.height - newFrame.size.height) - midHeight)) {
        newFrame.origin.y = barrierFrame.size.height - newFrame.size.height;
        needChange = NO;
    }
    
    if (needChange) {
        if ((newFrame.origin.x + midWidth) < barrierFrame.size.width / 2) {
            newFrame.origin.x = 0;
        } else {
            newFrame.origin.x = barrierFrame.size.width - newFrame.size.width;
        }
    }
    
    return newFrame;
}

///自由移动，贴边吸附
- (CGRect)frameHelperAbsorbEdge:(CGRect)userFrame barrierFrame:(CGRect)barrierFrame
{
    CGRect newFrame = userFrame;
    
    CGFloat midWidth = newFrame.size.width;
    CGFloat midHeight = newFrame.size.height;
    
    if (newFrame.origin.x < midWidth) {
        newFrame.origin.x = 0;
    }
    if (newFrame.origin.x > (barrierFrame.size.width - newFrame.size.width) - midWidth) {
        newFrame.origin.x = barrierFrame.size.width - newFrame.size.width;
    }
    if (newFrame.origin.y < midHeight) {
        newFrame.origin.y = 0;
    }
    if (newFrame.origin.y > (barrierFrame.size.height - newFrame.size.height) - midHeight) {
        newFrame.origin.y = barrierFrame.size.height - newFrame.size.height;
    }
    
    return newFrame;
}

@end

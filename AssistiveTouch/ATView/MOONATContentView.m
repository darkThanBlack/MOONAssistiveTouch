//
//  MOONATContentView.m
//  MOONCodes
//
//  Created by 月之暗面 on 2019/4/21.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATContentView.h"

NSString * const kMOONATContentViewOldCenter = @"kMOONATContentViewOldCenter";

@implementation MOONATContentConfig

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGRect:self.closeFrame forKey:@"closeFrame"];
    [aCoder encodeCGRect:self.openFrame forKey:@"openFrame"];
    [aCoder encodeInteger:self.absorbMode forKey:@"absorbMode"];
    [aCoder encodeBool:self.delayFadeMode forKey:@"delayFadeMode"];
    [aCoder encodeFloat:self.fadeAlpha forKey:@"fadeAlpha"];
    [aCoder encodeInteger:self.fadeDelay forKey:@"fadeDelay"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.closeFrame = [aDecoder decodeCGRectForKey:@"closeFrame"];
        self.openFrame = [aDecoder decodeCGRectForKey:@"openFrame"];
        self.absorbMode = [aDecoder decodeIntegerForKey:@"absorbMode"];
        self.delayFadeMode = [aDecoder decodeBoolForKey:@"delayFadeMode"];
        self.fadeAlpha = [aDecoder decodeFloatForKey:@"fadeAlpha"];
        self.fadeDelay = [aDecoder decodeIntegerForKey:@"fadeDelay"];
    }
    return self;
}

@end

#pragma mark -

@interface MOONATContentView ()

///记录拖动起始位置
@property (nonatomic, assign) CGPoint oldDragPoint;

///记录展示菜单前位置
@property (nonatomic, assign) CGRect oldTapFrame;

///当前是否为展示菜单状态
@property (nonatomic, assign) BOOL open;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger delay;

@property (nonatomic, strong) MOONATConfigSubViewCloseStateBlock closeBlock;
@property (nonatomic, strong) MOONATConfigSubViewOpenStateBlock openBlock;

@property (nonatomic, assign) CGRect openFrame;

@property (nonatomic, strong) MOONATContentConfig *config;

@end

@implementation MOONATContentView

#pragma mark -

- (MOONATContentConfig *)config
{
    if (!_config) {
        NSData *tmpData = [[NSUserDefaults standardUserDefaults]objectForKey:@"kMOONATResumableConfigKey"];
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
            _config.fadeDelay = 4.0;
        }
    }
    return _config;
}

- (void)dealloc
{
    NSData *tmpData = [NSKeyedArchiver archivedDataWithRootObject:self.config];
    [[NSUserDefaults standardUserDefaults]setObject:tmpData forKey:@"kMOONATResumableConfigKey"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - Interface

- (void)start
{
    self.delay = 4.0;
    self.open = NO;
    self.closeBlock(self);
    [self layoutIfNeeded];
}

- (void)startWithResumableConfig
{
    
    
}

- (void)configFrameWithOpenState:(CGRect)openFrame closeState:(CGRect)closeFrame
{
    self.frame = closeFrame;
    self.openFrame = openFrame;
}

- (void)updateContentViewState
{
    [self updateContentViewFrame:self.openFrame];
}

- (void)updateContentViewFrame:(CGRect)openingFrame
{
    CGRect updateFrame = CGRectZero;
    if (self.open) {
        updateFrame = self.oldTapFrame;
    } else {
        self.oldTapFrame = self.frame;  //记录打开菜单前的位置
        updateFrame = openingFrame;
    }
    self.open = !self.open;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = updateFrame;
        if (self.open) {
            self.openBlock(self);
        } else {
            self.closeBlock(self);
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ((!self.open) && self.delayFade) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(contentDelayFadeHandle:) userInfo:nil repeats:YES];
        }
    }];
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
    self.delay = 4.0;
    self.alpha = 1.0;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.open) {
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
    if (!self.open) {
        CGRect newFrame = [self frameHelperInside:self.frame barrierFrame:[UIScreen mainScreen].bounds];
        
        if (self.absorbMode == MOONATAbsorbModeSystem) {
            newFrame = [self frameHelperAbsorbSystem:newFrame barrierFrame:[UIScreen mainScreen].bounds];
        }
        if (self.absorbMode == MOONATAbsorbModeEdge) {
            newFrame = [self frameHelperAbsorbEdge:newFrame barrierFrame:[UIScreen mainScreen].bounds];
        }
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults]setObject:NSStringFromCGPoint(self.center) forKey:kMOONATContentViewOldCenter];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (self.delayFade) {
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
            self.alpha = 0.3;
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
    
    CGFloat midWidth = newFrame.size.width / 2.0;
    CGFloat midHeight = newFrame.size.height / 2.0;
    
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

//
//  MOONATMenuHelper.m
//  MOONATProject
//
//  Created by 徐一丁 on 2019/5/6.
//  Copyright © 2019 月之暗面. All rights reserved.
//

#import "MOONATMenuHelper.h"

@implementation MOONATMenuHelper

+ (UIImage *)imageNamed:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleUrl = [bundle URLForResource:@"MOONAssistiveTouchResource" withExtension:@"bundle"];
    NSBundle *currentBundle = nil;
    if (bundleUrl) {
       currentBundle = [NSBundle bundleWithURL:bundleUrl];
    } else {
        currentBundle = [NSBundle mainBundle];
    }
    
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:imageName inBundle:currentBundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[currentBundle pathForResource:imageName ofType:@"png"]];
    }
}

@end

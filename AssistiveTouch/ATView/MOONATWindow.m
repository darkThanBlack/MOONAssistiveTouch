//
//  MOONATWindow.m
//  MOONCodes
//
//  Created by 徐一丁 on 2019/4/19.
//  Copyright © 2019 moonShadow. All rights reserved.
//

#import "MOONATWindow.h"

@implementation MOONATWindow

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self.noResponseView]) {
        return nil;
    }
    return view;
}

@end

//
//  UIResponder+YCFirstResponder.m
//  LiveForest
//
//  Created by 余超 on 16/1/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIResponder+YCFirstResponder.h"

static id yc_firstResponder;

@implementation UIResponder (YCFirstResponder)

#pragma mark - 获取firstResponder
- (UIResponder *)yc_firstResponder {
    yc_firstResponder = nil;
    
    // to nil mean to current firstResponder.
    [[UIApplication sharedApplication]sendAction:@selector(yc_findFirstResponder) to:nil from:nil forEvent:nil];
    return yc_firstResponder;
}

- (void)yc_findFirstResponder {
    yc_firstResponder = self;
}

#pragma mark - 私有aip获取firstResponder，会被打回
- (UIResponder *)yc_firstResponder_bad {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIResponder *firstResponder = nil;
//    firstResponder = [window performSelector:@selector(firstResponder)];
    firstResponder = [window valueForKey:@"firstResponder"];
//    firstResponder = [controller valueForKey:@"firstResponder"];
//    firstResponder = [view valueForKey:@"firstResponder"];
//    NSLog(@"firstResponder = %@",firstResponder);
    return firstResponder;
}

#pragma mark - UIView递归获取firstResponder的获取方法
- (UIView *)yc_firstResponder:(UIView *)fromView {
    if ([fromView isFirstResponder]) {
        return fromView;
    }
    for (UIView *view in fromView.subviews) {
        UIView *first = [self yc_firstResponder:view];
        if (first) {
            return first;
        }
    }
    return nil;
}



@end

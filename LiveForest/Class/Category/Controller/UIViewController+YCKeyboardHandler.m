//
//  UIViewController+YCKeyboardHandler.m
//  LiveForest
//
//  Created by 余超 on 16/1/27.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIViewController+YCKeyboardHandler.h"

@implementation UIViewController (YCKeyboardHandler)

- (void)yc_addKeyboardHandler {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)yc_removeKeyboardHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self];
}

- (void)yc_addKeyboardHandlerForTarget:(UIView *)targetView {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_keyboardWillHide:) name:UIKeyboardWillHideNotification object:targetView];
}

- (void)yc_removeKeyboardHandlerForTarget:(UIView *)targetView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:targetView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:targetView];
}

- (void)yc_keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
    float keyboardHeight = frame.CGRectValue.size.height;
//    NSLog(@"%@",userInfo);
//    NSLog(@"发起者 %@",notification.object);
    UIView *first = [self yc_firstResponder:self.view];
    HSLog(@"fitst %@",first);

    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.origin = CGPointMake(0, -keyboardHeight);
    }];
}

- (void)yc_keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.origin = CGPointMake(0, 0);
    }];
}

// 获取 firstResponder
//UIWindow *window = [UIApplication sharedApplication].keyWindow;
//UIView *first = [window performSelector:@selector(firstResponder)];
//first = [window valueForKey:@"firstResponder"];
//first = [self valueForKey:@"firstResponder"];
//first = [self.view valueForKey:@"firstResponder"];
//NSLog(@"%d",[self.view isFirstResponder]);
//HSLog(@"fitst %@",first);

//- (UIView *)yc_firstResponder:(UIView *)sv {
//    for (UIView *view in sv.subviews) {
//        if ([view isFirstResponder]) {
//            return view;
//        } else {
//            [self yc_firstResponder:view];
//        }
//    }
//    return nil;
//}

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

//[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

@end

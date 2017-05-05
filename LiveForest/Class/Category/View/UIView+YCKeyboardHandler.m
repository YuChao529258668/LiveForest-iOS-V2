//
//  UIView+YCKeyboardHandler.m
//  LiveForest
//
//  Created by 余超 on 16/1/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIView+YCKeyboardHandler.h"
#import <objc/runtime.h>

NSString *const YCMoveViewKey = @"YCKeyboardHandlerMoveView";
NSString *const YCToViewKey = @"YCKeyboardHandlerToView";
NSString *const YCBelowViewKey = @"YCKeyboardHandlerBelowView";
NSString *const YCShouldAddMaskButtonKey = @"YCKeyboardHandlerShouldAddMaskButton";

@implementation UIView (YCKeyboardHandler)
//@dynamic keyboardWillHideBlock;

#pragma mark - Public

- (void)yc_addKeyboardHandlerWithMoveView:(UIView *)moveView {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_moveTargetViewWithNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_moveTargetViewWithNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setMoveView:moveView];
    [self setShouldAddMaskButton:NO];
}

- (void)yc_addKeyboardHandlerWithMoveView:(UIView *)moveView andInsertMaskButtonTo:(UIView *)toView below:(UIView *)belowView {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_moveTargetViewWithNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yc_moveTargetViewWithNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setMoveView:moveView];
    [self setToView:toView];
    [self setBelowView:belowView];
    [self setShouldAddMaskButton:YES];
}

- (void)yc_removeKeyboardHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Actions
- (void)yc_moveTargetViewWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
    float keyboardHeight = frame.CGRectValue.size.height;
    NSNumber *duration = userInfo[UIKeyboardAnimationDurationUserInfoKey];

    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        keyboardHeight = 0;
        
        if ([self keyboardWillHideBlock]) {
            [self keyboardWillHideBlock]();
        }
    } else {
        if (self.isFirstResponder == NO) { // 此时还没放弃firstResponder
            return;
        }
        if ([self shouldAddMaskButton]) {
            [self yc_addMaskButton];
        }
        if ([self keyboardWillShowBlock]) {
            [self keyboardWillShowBlock]();
        }

    }
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [self moveView].transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

- (void)yc_addMaskButton {
//    keyboardWillShow通知会发送3次，不知为啥，因此会添加3个maskBtn，所以要通过tag来判断是否添加过maskBtn了。
    NSInteger tag = 329847;
    UIButton *btn =[[self toView] viewWithTag:tag]; // toView表示要添加maskBtn的view。
    if (btn) return; // 如果已经添加过了，直接返回。
    
    btn = [self makeMaskBtn];
    btn.tag = tag;
    [[self toView] insertSubview:btn belowSubview:[self belowView]];
}

- (UIButton *)makeMaskBtn {
    UIButton *btn = [UIButton new];
    btn.frame = [UIScreen mainScreen].bounds;
    [btn addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0.3 alpha:0.5];
    return btn;
}

- (void)closeKeyboard:(UIButton *)btn {
    [self resignFirstResponder];
    [btn removeFromSuperview];
}

#pragma mark - Runtime
- (void)setMoveView:(UIView *)moveView {
    objc_setAssociatedObject(self, (__bridge const void *)(YCMoveViewKey), moveView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)moveView {
    return (UIView *)objc_getAssociatedObject(self, (__bridge const void *)(YCMoveViewKey));
}

- (void)setToView:(UIView *)toView {
    objc_setAssociatedObject(self, (__bridge const void *)(YCToViewKey), toView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)toView {
    return (UIView *)objc_getAssociatedObject(self, (__bridge const void *)(YCToViewKey));
}

- (void)setBelowView:(UIView *)belowView {
    objc_setAssociatedObject(self, (__bridge const void *)(YCBelowViewKey), belowView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)belowView {
    return (UIView *)objc_getAssociatedObject(self, (__bridge const void *)(YCBelowViewKey));
}

- (void)setShouldAddMaskButton:(BOOL)shouldAddBtn {
    objc_setAssociatedObject(self, (__bridge const void *)(YCShouldAddMaskButtonKey), @(shouldAddBtn), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)shouldAddMaskButton {
    NSNumber *shouldAddBtn = (NSNumber *)objc_getAssociatedObject(self, (__bridge const void *)(YCShouldAddMaskButtonKey));
    return shouldAddBtn.intValue;
}

- (void)setKeyboardWillShowBlock:(void(^)())block {
    objc_setAssociatedObject(self, (__bridge const void *)(@"YCKeyboardWillShowBlockKey"), block, OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)())keyboardWillShowBlock {
    void (^block)() = objc_getAssociatedObject(self, (__bridge const void *)(@"YCKeyboardWillShowBlockKey"));
    return block;
}

- (void)setKeyboardWillHideBlock:(void(^)())block {
    objc_setAssociatedObject(self, (__bridge const void *)(@"YCKeyboardWillHideBlockKey"), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())keyboardWillHideBlock {
    void (^block)() = objc_getAssociatedObject(self, (__bridge const void *)(@"YCKeyboardWillHideBlockKey"));
    return block;
}

@end

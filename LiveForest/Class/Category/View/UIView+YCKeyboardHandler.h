//
//  UIView+YCKeyboardHandler.h
//  LiveForest
//
//  Created by 余超 on 16/1/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YCKeyboardHandler)

//- (void)yc_addKeyboardHandlerForMovingTarget:(UIView *)targetView;
//- (void)yc_addKeyboardHandlerFor:(UIView *)targetView andMaskButtonTo:(UIView *)toView;

@property (nonatomic, copy) void (^keyboardWillShowBlock)() ;
@property (nonatomic, copy) void (^keyboardWillHideBlock)() ;


- (void)yc_addKeyboardHandlerWithMoveView:(UIView *)moveView;
- (void)yc_addKeyboardHandlerWithMoveView:(UIView *)moveView andInsertMaskButtonTo:(UIView *)toView below:(UIView *)belowView;

- (void)yc_removeKeyboardHandler;

@end

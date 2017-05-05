//
//  UIViewController+YCKeyboardHandler.h
//  LiveForest
//
//  Created by 余超 on 16/1/27.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YCKeyboardHandler)

- (void)yc_addKeyboardHandler;
- (void)yc_removeKeyboardHandler;

- (void)yc_addKeyboardHandlerForTarget:(UIView *)targetView;
- (void)yc_removeKeyboardHandlerForTarget:(UIView *)targetView;

@end

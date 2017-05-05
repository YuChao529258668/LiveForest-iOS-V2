//
//  UIView+HSController.m
//  LiveForest
//
//  Created by 余超 on 16/1/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIView+HSController.h"

@implementation UIView (HSController)

- (UIViewController *)hs_controller {
    UIViewController *vc = nil;
    for (UIResponder *next = self.nextResponder; next; next = next.nextResponder) {
        HSLog(@"控制器 %@",next.class);
        if ([next isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)next;
            break;
        }
        if ([next isKindOfClass:[UIWindow class]]) {
            UIWindow *window = (UIWindow *)next;
            vc = window.rootViewController;
            HSLog(@"导航控制器 %@",vc.navigationController);
            break;
        }
    }
    
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        HSLog(@"控制器2 %@",nextResponder.class);
//        
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;

    return vc;
    
}

@end

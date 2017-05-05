//
//  UIViewController+HSShow.m
//  LiveForest
//
//  Created by 余超 on 16/1/15.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIViewController+HSShow.h"

@implementation UIViewController (HSShow)

- (void)hs_showToViewController:(UIViewController *)vc {
    [vc addChildViewController:self];
    [vc.view addSubview:self.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect f = self.view.frame;
    f.origin.y = bounds.size.height;
    self.view.frame = f;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = bounds;
    } completion:nil];
}

- (void)hs_dismissFromViewController:(UIViewController *)vc {
    // 这个方法没被调用，为啥
    NSLog(@"hs_dismissFromViewController");
    CGRect f = self.view.frame;
    f.origin.y = CGRectGetMaxY([UIScreen mainScreen].bounds);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];

}

- (void)hs_showViewController:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect f = vc.view.frame;
    f.origin.y = bounds.size.height;
    vc.view.frame = f;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        vc.view.frame = bounds;
    } completion:nil];
}

- (void)hs_dismissViewController:(UIViewController *)vc {
    CGRect f = vc.view.frame;
    f.origin.y = CGRectGetMaxY([UIScreen mainScreen].bounds);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        vc.view.frame = f;
    } completion:^(BOOL finished) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }];
    
}

- (void)hs_dismissViewController {
    CGRect f = self.view.frame;
    f.origin.y = CGRectGetMaxY([UIScreen mainScreen].bounds);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}

@end

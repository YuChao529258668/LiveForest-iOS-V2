//
//  UIViewController+HSShow.h
//  LiveForest
//
//  Created by 余超 on 16/1/15.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HSShow)

- (void)hs_showToViewController:(UIViewController *)vc;
- (void)hs_dismissFromViewController:(UIViewController *)vc;

- (void)hs_showViewController:(UIViewController *)vc;
- (void)hs_dismissViewController:(UIViewController *)vc;
- (void)hs_dismissViewController;

@end

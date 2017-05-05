//
//  UIViewController+HSBarItem.m
//  LiveForest
//
//  Created by 余超 on 16/4/7.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIViewController+HSBarItem.h"

@implementation UIViewController (HSBarItem)

- (UIBarButtonItem *)hs_itemWithNormal:(NSString *)n Selected:(NSString *)h target:(id)target action:(SEL)selector {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:n] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:h] forState:UIControlStateSelected];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}

@end

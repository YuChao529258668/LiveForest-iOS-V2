//
//  HSNavigationController.m
//  LiveForest
//
//  Created by 余超 on 16/1/5.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNavigationController.h"

#import "HSNavigationMenu.h"
#import "HSNavigationHistoryMenu.h"
#import "HSMaskButton.h"

#import "UIStoryboard+HSController.h"

@interface HSNavigationController ()

@end

@implementation HSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置透明
//    UIImage *image = [UIImage imageNamed:@"tran"];
//    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // 设置背景色
    self.navigationBar.barTintColor = [UIColor colorWithRed:0x62/255.0 green:0x61/255.0 blue:0x61/255.0 alpha:1]; // 626161
    
    // 设置字体和颜色
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [self.navigationBar setTitleTextAttributes:dic];
    
    
    // 设置按钮
    UIBarButtonItem *leftItem = [self itemWithNormal:@"btn_meun_n" Selected:@"btn_meun_h" target:self action:@selector(leftMenuBtnClick:)];
    UIBarButtonItem *notifyItem = [self itemWithNormal:@"btn_note_n" Selected:@"btn_note_h" target:self action:@selector(notififationBtnClick:)];
    UIBarButtonItem *historyItem = [self itemWithNormal:@"btn_history_n" Selected:@"btn_history_h" target:self action:@selector(historyBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItems = @[notifyItem,historyItem];
}

#pragma mark - Actions

- (void)leftMenuBtnClick:(UIButton *)btn {
    btn.selected = YES;
    
    HSNavigationMenu *menu = [self createMenuPointTo:btn];
    
    HSMaskButton *mbtn = [HSMaskButton maskButtonWithBlock:^{
        btn.selected = NO;
    }];
    [mbtn addSubview:menu];
    [mbtn addToWindow];
}

- (void)notififationBtnClick:(UIButton *)btn {
//    btn.selected = YES;
//    
//    HSNavigationMenu *menu = [self createMenuPointTo:btn];
//    
//    HSMaskButton *mbtn = [HSMaskButton maskButtonWithBlock:^{
//        btn.selected = NO;
//    }];
//    [mbtn addSubview:menu];
//    [mbtn addToWindow];
    
    UIViewController *vc = [UIStoryboard hs_controllerOfName:@"HSNotificationListController" storyBoard:@"Personal"];
    [self pushViewController:vc animated:YES];
}

- (void)historyBtnClick:(UIButton *)btn {
    btn.selected = YES;
    
    HSNavigationHistoryMenu *menu = [self createHistoryMenuPointTo:btn];
    
    HSMaskButton *maskButton = [HSMaskButton maskButtonWithBlock:^{
        btn.selected = NO;
    }];
    [maskButton addSubview:menu];
    [maskButton addToWindow];
    
    __weak HSMaskButton *weakMaskButton = maskButton;
    menu.yueBanHistoryBtnClick = ^ {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
        UIViewController *toVC = [sb instantiateViewControllerWithIdentifier:@"HSYueBanHistoryController"];
        [self pushViewController:toVC animated:YES];

        btn.selected = NO;
        [weakMaskButton removeFromSuperview];
    };
    menu.challengeHistoryBtnClick = ^ {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
        UIViewController *toVC = [sb instantiateViewControllerWithIdentifier:@"HSYChallengeHistoryController"];
        [self pushViewController:toVC animated:YES];
        
        btn.selected = NO;
        [weakMaskButton removeFromSuperview];
    };
}

#pragma mark - Helper

- (HSNavigationMenu *)createMenuPointTo:(UIView *)view {
    HSNavigationMenu *menu = [HSNavigationMenu new];
    
    menu.y = CGRectGetMaxY(self.navigationBar.frame);
    
    CGPoint toWindow = [view.superview convertPoint:view.center toView:nil];
    CGPoint fromWindow = [menu convertPoint:toWindow fromView:nil];
    float centerX = fromWindow.x;
    menu.triangle.center = CGPointMake(centerX, menu.triangle.center.y);
    
//    在模拟器，三个点是一样的，真机6也是一样的，但是真机6p的hhh和另外两点不一样。。。
//    CGPoint h = [view.superview convertPoint:view.center toView:nil];
//    HSLog(@"h.x = %f",h.x);
//    CGPoint hh = [menu convertPoint:h fromView:nil];
//    HSLog(@"hh.x = %f",hh.x);
//    CGPoint hhh = [view.superview convertPoint:view.center toView:menu];
//    HSLog(@"hhh.x = %f",hhh.x);
//    float centerX = [view.superview convertPoint:view.center toView:menu].x;

    return menu;
}

- (HSNavigationHistoryMenu *)createHistoryMenuPointTo:(UIView *)view {
    HSNavigationHistoryMenu *menu = [HSNavigationHistoryMenu new];
    
    menu.y = CGRectGetMaxY(self.navigationBar.frame);
    
    CGPoint toWindow = [view.superview convertPoint:view.center toView:nil];
    CGPoint fromWindow = [menu convertPoint:toWindow fromView:nil];
    float centerX = fromWindow.x;
    menu.triangle.center = CGPointMake(centerX, menu.triangle.center.y);
    
    return menu;
}

- (UIBarButtonItem *)itemWithNormal:(NSString *)n Selected:(NSString *)h target:(id)target action:(SEL)selector {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:n] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:h] forState:UIControlStateSelected];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}

@end

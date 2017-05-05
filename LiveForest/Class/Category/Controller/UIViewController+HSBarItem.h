//
//  UIViewController+HSBarItem.h
//  LiveForest
//
//  Created by 余超 on 16/4/7.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HSBarItem)
- (UIBarButtonItem *)hs_itemWithNormal:(NSString *)n Selected:(NSString *)h target:(id)target action:(SEL)selector;

@end

//
//  UINavigationBar+HSAttributes.h
//  LiveForest
//
//  Created by 傲男 on 16/2/4.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (HSAttributes)
/**
 *   自定义设置NavigationBar的title的字体大小与颜色(强)
 *  @param target 导航控制器
 *  @param TextColor 字体颜色
 *  @param FontOfSize 字体大小
 */
+ (void)setAttributesWithTarget:(UINavigationController*)target TextColor:(UIColor *)color FontOfSize:(CGFloat)size;
@end

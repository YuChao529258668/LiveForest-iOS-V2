//
//  UIBarButtonItem+HSUIBarButtonItem.h
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HSUIBarButtonItem)
/**
 *  自定义创建一个item（强）
 *  @param action 点击item调用的方法
 *  @param image 图片
 *  @param sender sender button
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image;

@end

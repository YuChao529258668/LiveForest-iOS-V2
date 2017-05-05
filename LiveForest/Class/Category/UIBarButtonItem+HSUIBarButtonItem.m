//
//  UIBarButtonItem+HSUIBarButtonItem.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIBarButtonItem+HSUIBarButtonItem.h"

@implementation UIBarButtonItem (HSUIBarButtonItem)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    //设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end

//
//  UINavigationBar+HSAttributes.m
//  LiveForest
//
//  Created by 傲男 on 16/2/4.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UINavigationBar+HSAttributes.h"

@implementation UINavigationBar (HSAttributes)

+ (void)setAttributesWithTarget:(UINavigationController*)target TextColor:(UIColor *)color FontOfSize:(CGFloat)size{
    
     [target.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,UITextAttributeTextColor,[UIFont systemFontOfSize:size],NSFontAttributeName, nil]];
}

@end

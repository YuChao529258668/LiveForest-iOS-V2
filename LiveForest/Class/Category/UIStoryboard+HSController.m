//
//  UIStoryboard+HSController.m
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIStoryboard+HSController.h"

@implementation UIStoryboard (HSController)

+ (UIViewController *)hs_controllerOfName:(NSString *)name storyBoard:(NSString *)sb {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sb bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:name];
    return vc;
}

@end

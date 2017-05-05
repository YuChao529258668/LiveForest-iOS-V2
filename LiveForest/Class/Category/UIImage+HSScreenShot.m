//
//  UIImage+HSScreenShot.m
//  LiveForest
//
//  Created by 余超 on 16/1/15.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIImage+HSScreenShot.h"

@implementation UIImage (HSScreenShot)

+ (UIImage *)hs_screenshotFromViewController:(UIViewController *)vc {
//    UIGraphicsBeginImageContext(vc.view.frame.size);
    UIGraphicsBeginImageContextWithOptions(vc.view.size, NO, [UIScreen mainScreen].scale);
    [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

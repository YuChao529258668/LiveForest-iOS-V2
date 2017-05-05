//
//  UIStoryboard+HSController.h
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (HSController)
+ (UIViewController *)hs_controllerOfName:(NSString *)name storyBoard:(NSString *)sb;
@end

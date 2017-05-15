//
//  AppDelegate.h
//  LiveForest
//
//  Created by 余超 on 15/11/25.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

#import "HSDataFormatHandle.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

/// 用于第三方判断是否需要注册。新用户注册的时候设置为yes，默认是no，退出登录的时候设置为no
@property (nonatomic) BOOL isNewUser;

@end


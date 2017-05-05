//
//  HSNotificationTool.m
//  LiveForest
//
//  Created by 余超 on 16/9/18.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


//        UIApplicationWillTerminateNotification
NSString *const HSLoginSuccessNotification = @"HSLoginSuccessNotification";



#import "HSNotificationTool.h"

@implementation HSNotificationTool

+ (void)postLoginSuccessNotification {
    [[NSNotificationCenter defaultCenter]postNotificationName:HSLoginSuccessNotification object:nil];
}

+ (void)addLoginObserver:(id)observer selector:(SEL)aSelector object:(nullable id)anObject {
     [[NSNotificationCenter defaultCenter]addObserver:observer selector:aSelector name:HSLoginSuccessNotification object:anObject];
}

+ (void)removeLoginObserver:(id)observer object:(nullable id)anObject {
    [[NSNotificationCenter defaultCenter]removeObserver:observer name:HSLoginSuccessNotification object:anObject];
}

@end

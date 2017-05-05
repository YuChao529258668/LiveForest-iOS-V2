//
//  HSNotificationTool.h
//  LiveForest
//
//  Created by 余超 on 16/9/18.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


extern NSString *const HSLoginSuccessNotification;



#import <Foundation/Foundation.h>

@interface HSNotificationTool : NSObject

+ (void)postLoginSuccessNotification;
+ (void)addLoginObserver:(id)observer selector:(SEL)aSelector object:(nullable id)anObject;
+ (void)removeLoginObserver:(id)observer object:(nullable id)anObject;

@end


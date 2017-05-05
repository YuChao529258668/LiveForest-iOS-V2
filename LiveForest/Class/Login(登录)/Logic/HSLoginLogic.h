//
//  HSLoginLogic.h
//  LiveForest
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kLogoutNotification;

@interface HSLoginLogic : NSObject

#pragma mark 处理登出事件
+ (Boolean) doLogOut;

//#pragma mark 判断是否登录，如果没有登录则跳转到登录页面
//+ (Boolean) isLogin:(Boolean)orForward;

#pragma mark 判断是否登录过了,如果没登陆并需要跳转到登陆界面，则跳转，否则返回false
+ (void) isLogin:(Boolean)doForward andCallBack:(void(^)(Boolean isLogin))CB;


#pragma mark 判断是否过期,如果过期并需要跳转到登陆界面，则跳转，否则回调返回是否过期
+ (void) isExpired:(Boolean)doForward andCallBack:(void(^)(Boolean isExpired))CB;

@end

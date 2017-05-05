//
//  HSUserModelDAO.h
//  LiveForest
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSHttpRequestTool.h"
#import <ShareSDK/ShareSDK.h>

@class HSUserModel;

@interface HSUserModelDAO:HSHttpRequestTool

#pragma mark 根据用户编号或者Token获取用户信息
+ (void) getUserInfoWithUserId:(nullable NSString *)userId orUserToken:(nullable NSString*)userToken andRequestCB:(void(^)( HSUserModel *user))CallBack;

#pragma mark 用户登录与登出
+ (void) doLoginWithUserPhone:(NSString*)userPhone andUserLoginPassword:userLoginPassword andRequestCB:(void(^)(NSString* userId))CallBack;

#pragma mark 使用UserToken进行登录
+ (void) doLoginWithUserToken:(NSString*)userToken andRequestCB:(void(^)(NSString* userId))CallBack;

#pragma mark 使用第三方登录
+ (void) doLoginWithThridSource:(NSString*)thirdSource
                      andOpenId:(NSString*)openId
                    andUserInfo:(id<ISSPlatformUser>)userInfo
                   andRequestCB:(void(^)(NSString* userId))CallBack;

@end

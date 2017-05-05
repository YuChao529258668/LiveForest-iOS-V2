//
//  HSRegisterDAO.h
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSHttpRequestTool.h"

@interface HSRegisterDAO : HSHttpRequestTool

#pragma mark 验证手机号
+ (void)verifyPhoneNum:(NSString *)phone andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 获取验证码
+(void)getCheckNum:(NSString *)phone andCallBack:(void(^)(bool, NSString *))CB;

#pragma mark 注册手机密码
+(void)registerPhone:(NSString *)phone andPassword:(NSString *)password andCheckNum:(NSString *)checkNum andCallBack:(void(^)(bool, NSString *))CB;

#pragma mark 校验验证码
+ (void)verifyCheckNum:(NSString *)phone andCheckNum:(NSString *)checkNum andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 完善个人信息


#pragma mark 兴趣爱好

@end

//
//  HSHSPersonalInfoManagementDAO.h
//  LiveForest
//
//  Created by 傲男 on 16/2/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSHttpRequestTool.h"

@interface HSPersonalInfoManagementDAO : HSHttpRequestTool

#pragma mark 完善个人信息

#pragma mark 修改某个用户的昵称
+ (void)updatePersonNickname:(NSString *)nickName andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 修改某个用户的性别
+ (void)updatePersonSex:(NSString *)user_sex andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 修改某个用户的生日
+ (void)updatePersonBirthday:(NSString *)user_sex andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 修改某个用户的头像
+ (void)updatePersonLogo:(NSString *)user_logo_img_path andCallBack:(void (^)(bool, NSString *))CB;

#pragma mark 兴趣标签
+ (void)updatePersonSportTag:(NSArray *)user_sport_tag andCallBack:(void (^)(bool, NSString *))CB;
@end

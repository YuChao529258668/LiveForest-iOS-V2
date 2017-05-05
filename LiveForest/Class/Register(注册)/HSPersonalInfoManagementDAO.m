//
//  HSHSPersonalInfoManagementDAO.m
//  LiveForest
//
//  Created by 傲男 on 16/2/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSPersonalInfoManagementDAO.h"

@implementation HSPersonalInfoManagementDAO


#pragma mark 完善个人信息
#pragma mark 修改某个用户的昵称
+ (void)updatePersonNickname:(NSString *)nickName andCallBack:(void (^)(bool, NSString *))CB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //判断token是否存在
    if(!user_token){
        //不存在，则提示无法操作
        return CB(false, @"用户鉴权失败!");
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nickName,@"user_nickname",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonNicknameURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(@"%@",error);
            
            return CB(false,[[NSString alloc]initWithFormat:@"提交失败:%@",error]);
            
        }
        
    }];
}

#pragma mark 修改某个用户的性别
+ (void)updatePersonSex:(NSString *)user_sex andCallBack:(void (^)(bool, NSString *))CB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //判断token是否存在
    if(!user_token){
        //不存在，则提示无法操作
        return CB(false, @"用户鉴权失败!");
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",user_sex,@"user_sex",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonSexURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(@"%@",error);;
            
            return CB(false,[[NSString alloc]initWithFormat:@"提交失败:%@",error]);
            
        }
        
    }];
}

#pragma mark 修改某个用户的生日
+ (void)updatePersonBirthday:(NSString *)user_birthday andCallBack:(void (^)(bool, NSString *))CB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //判断token是否存在
    if(!user_token){
        //不存在，则提示无法操作
        return CB(false, @"用户鉴权失败!");
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",user_birthday,@"user_birthday",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonBirthdayURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(@"%@",error);;
            
            return CB(false,[[NSString alloc]initWithFormat:@"提交失败:%@",error]);
            
        }
        
    }];
}
#pragma mark 修改某个用户的头像
+ (void)updatePersonLogo:(NSString *)user_logo_img_path andCallBack:(void (^)(bool, NSString *))CB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //判断token是否存在
    if(!user_token){
        //不存在，则提示无法操作
        return CB(false, @"用户鉴权失败!");
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",user_logo_img_path,@"user_logo_img_path",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonLogoURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(@"%@",error);;
            
            return CB(false,[[NSString alloc]initWithFormat:@"提交失败:%@",error]);
            
        }
        
    }];
}
#pragma mark 兴趣标签
+ (void)updatePersonSportTag:(NSArray *)user_sport_tag andCallBack:(void (^)(bool, NSString *))CB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //判断token是否存在
    if(!user_token){
        //不存在，则提示无法操作
        return CB(false, @"用户鉴权失败!");
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",user_sport_tag,@"user_sport_tag",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonSportTagURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(@"%@",error);;
            
            return CB(false,[[NSString alloc]initWithFormat:@"提交失败:%@",error]);
            
        }
        
    }];
}
@end

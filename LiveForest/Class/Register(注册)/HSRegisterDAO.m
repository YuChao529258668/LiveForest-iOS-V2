//
//  HSRegisterDAO.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSRegisterDAO.h"

@implementation HSRegisterDAO

#pragma mark 验证手机号
+ (void)verifyPhoneNum:(NSString *)phone andCallBack:(void (^)(bool, NSString *))CB{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"user_phone",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doPhoneVerifyURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            return CB(true,nil);
            
        }else{
            
            //获取失败
            
            //打印错误
            HSLog(error);
            
            return CB(false, [[NSString alloc]initWithFormat:@"手机校验失败:%@",error]);
            
            
        }
        
    }];

}

#pragma mark 获取验证码}

+ (void)getCheckNum:(NSString *)phone andCallBack:(void (^)(bool, NSString *))CB{
    
    //首先验证手机号，如果通过，则发送验证码
    [self verifyPhoneNum:phone andCallBack:^(bool success, NSString *error) {
        if(success){
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"user_phone",nil];
            
            NSDictionary *requestData;
            
            NSString *url;
            
            
            //构造请求数据
            requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
            
            //构造请求路径，请求个人信息
            url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doVerificationCodeSendURL];
            
            //发起请求
            [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
                
                if(code){
                    
                    //获取成功
                    return CB(true,nil);
                    
                }else{
                    
                    //获取失败
                    
                    //打印错误
                    HSLog(@"%s,%@",__func__, error.description);
                    
                    return CB(false,[[NSString alloc]initWithFormat:@"发送验证码失败:%@",error]);
                    
                    
                }
                
            }];
            
        }
        else{
            return CB(false,error);
        }
    }];
}

#pragma mark 校验验证码
+ (void)verifyCheckNum:(NSString *)phone andCheckNum:(NSString *)checkNum andCallBack:(void (^)(bool, NSString *))CB{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"user_phone",checkNum,@"checkCode",nil];
    
    NSDictionary *requestData;
    
    NSString *url;
    
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doVerificationCodeCheckURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //获取成功
            return CB(true,nil);
            
        }else{
            
            //获取失败
            
            //打印错误
            HSLog(error);
            
            return CB(false,[[NSString alloc]initWithFormat:@"验证码错误:%@",error]);
            
            
        }
        
    }];

}

#pragma mark 注册手机密码
+ (void)registerPhone:(NSString *)phone andPassword:(NSString *)password andCheckNum:(NSString *)checkNum andCallBack:(void (^)(bool, NSString *))CB{
    
    //先校验验证码，如果验证码没问题，则提交手机密码
    [self verifyCheckNum:phone andCheckNum:checkNum andCallBack:^(bool success, NSString *error) {
        if(success){
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"user_phone",password,@"user_login_pwd",
                                 @"1",@"user_login_platform",nil];
            
            NSDictionary *requestData;
            
            NSString *url;
            
            
            //构造请求数据
            requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
            
            //构造请求路径，请求个人信息
            url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doRegisterURL];
            
            //发起请求
            [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
                
                if(code){
                    
                    //获取成功
                    return CB(true,nil);
                    
                }else{
                    
                    //获取失败
                    
                    //打印错误
                    HSLog(error);
                    
                    return CB(false,[[NSString alloc]initWithFormat:@"注册失败:%@",error]);
                    
                    
                }
                
            }];
        }
        else{
            return CB(false,[[NSString alloc]initWithFormat:@"注册失败:%@",error]);
        }
    }];

}

@end

//
//  HSLoginLogic.m
//  LiveForest
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSLoginLogic.h"
#import "HSLoginViewController.h"
#import "HSConstantURL.h"
#import "HSUserModelDAO.h"
#import "AppDelegate.h"

NSString * const kLogoutNotification = @"HSLogoutNotification";

@interface HSLoginLogic()

@end


#pragma mark 处理对应的登录相关的业务逻辑
@implementation HSLoginLogic


-(instancetype)init {
    self = [super init];
    
    return self;
}

#pragma mark 登出，成功则返回YES
+ (Boolean)doLogOut{
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kLogoutNotification object:nil];
    
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ad.isNewUser = NO;

    //删除本地的user_token
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_token"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_token"];
    [userDefaults synchronize];
    HSLog(@"user_token = %@, %s", [userDefaults objectForKey:@"user_token"], __func__);

    //关闭当前界面
//    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    //跳转到登录页面
//    [[UIApplication sharedApplication] keyWindow].rootViewController = [[HSLoginViewController alloc]init];
    //未登录或者过期
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    HSLoginViewController *HSLoginVC = (HSLoginViewController *)[sb instantiateViewControllerWithIdentifier:@"HSLoginViewController"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:HSLoginVC];
//    [[UIApplication sharedApplication] keyWindow].rootViewController = HSLoginVC;
    [[UIApplication sharedApplication] keyWindow].rootViewController = nc;
    
    
    
    return YES;
}

#pragma mark 判断是否登录或者是否过期，如果尚未登录则跳转到注册界面
// orForward true 则表示跳转，否则不跳转
//+ (Boolean)isLogin:(Boolean)orForward{    //问题太多
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    //首先判断本地是否有user_token
//    if([userDefaults objectForKey:@"user_token"] == NULL){
//        //本地不存在user_token
//        if(orForward){
//            [self doLogOut];
//        }
//        
//        return NO;
//    }
//    
//    return YES;
//
//}


+ (void)isLogin:(Boolean)doForward andCallBack:(void (^)(Boolean))CB{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //首先判断本地是否有user_token
    if([userDefaults objectForKey:@"user_token"] == NULL){
        //本地不存在user_token
        if(doForward){
            [self doLogOut];
        }
        return CB(false);
    }
    else{
        //判断token是否过期
        [self isExpired:false andCallBack:^(Boolean isExpired){
            if(isExpired){
                if(doForward){
                    [self doLogOut];
                }
                return CB(false);
            }
            return CB(true);
        }];
    }
    
}

+ (void)isExpired:(Boolean)doForward andCallBack:(void (^)(Boolean isExpired))CB{
    
    //判断是否过期
    //尝试请求用户数据，如果请求失败，则会自动跳转
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [userDefaults objectForKey:@"user_token"];
    
    [HSUserModelDAO getUserInfoWithUserId:NULL orUserToken:userToken andRequestCB:^(HSUserModel *user) {
        
        //判断是否为空，如果为空直接跳转
        if(user == NULL){//过期
            
            if(doForward){ //如果需要跳转，则直接执行跳转
            [self doLogOut];
            }
            //回调函数返回结果，过期
            return CB(true);
        }
        else{
            //没有过期
            return CB(false);
        }
    }];

}

@end

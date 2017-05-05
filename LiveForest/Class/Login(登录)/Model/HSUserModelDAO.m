//
//  HSUserModelDAO.m
//  LiveForest
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSUserModelDAO.h"
#import "ServiceHeader.h"
#import "HSUserModel.h"
#import "HSRegisterViewController.h"

@implementation HSUserModelDAO

#pragma mark 根据用户编号或者Token获取用户信息
+ (void) getUserInfoWithUserId:(nullable NSString *)userId orUserToken:(nullable NSString*)userToken andRequestCB:(void(^)(HSUserModel* user))CallBack{
    
    NSDictionary *dic;
    
    NSDictionary *requestData;
    
    NSString *url;
    
    //判断是否存在userId
    if(userId == nil){
//        if (userToken == nil) {
//            ShowHint(@"userToken为空");
//            return;
//        }
        //如果用户ID为空，则默认获取的自己的数据
        dic = @{@"user_token":userToken};

    }else{
        //如果用户ID不为空，则是获取某个用户的数据
        dic = [[NSDictionary alloc]initWithObjectsAndKeys:userToken,@"user_token",
               userId,@"user_id", nil];
    }
    
    //构造请求数据
    requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    //构造请求路径，请求个人信息
    url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getPersonInfoURL];
    
    //发起请求
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //todo
            
            //获取成功
            id userInfo = [responseObject objectForKey:@"userInfo"];
            
//            HSUserModel* user =[HSUserModel mj_objectArrayWithKeyValuesArray:userInfo];  //返回nil
            HSUserModel* user =[HSUserModel mj_objectWithKeyValues:userInfo];  //返回nil

            CallBack(user);
            
            //将数据放置到本地缓存
            RLMRealm *realm = [RLMRealm defaultRealm];
            // 每个线程只需要使用一次即可
            
            // 通过事务将数据添加到 Realm 中
            [realm beginWriteTransaction];
            [HSUserModel createOrUpdateInRealm:realm withValue:user]; 
            [realm commitWriteTransaction];
            
             
            
        }else{
            
            //获取失败
            //打印错误
            HSLog(error);
            
            if(!userId){
                return CallBack(nil);;
            }
            
            //从本地缓存尝试获取
            RLMResults<HSUserModel> *users = [HSUserModel objectForPrimaryKey:userId];
            
            if([users count] > 0){
                //抽取第一条数据
                CallBack([users objectAtIndex:0]);
            }else{
                //如果连本地缓存都没有，则返回为空
                CallBack(nil);
            }
            
            
        }
        
    }];
    
}

#pragma mark 执行用户登录操作，使用UserToken
+ (void) doLoginWithUserToken:(NSString*)userToken andRequestCB:(void(^)(NSString* userId))CallBack{
    
    //获取设备编号
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
    
    //构造数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         userToken,@"user_token",
                         @"1",@"user_login_platform",
                         uuid,@"user_mac",
                         nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doLoginURL];
    
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //只会返回user_id与user_token
            [[NSUserDefaults standardUserDefaults]
             setObject:[responseObject objectForKey:@"user_token"]
             forKey:@"user_token"];
            
            if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                
                [[NSUserDefaults standardUserDefaults]
                 setObject:[responseObject objectForKey:@"user_id"]
                 forKey:@"user_id"];
            }
            else{
                HSLog(@"没有返回id,id不是string, id = %@", [responseObject objectForKey:@"user_id"]);
            }
            
            //登录成功，跳转到主界面
            CallBack([responseObject objectForKey:@"user_id"]);
            
            //请求用户信息
            [self getUserInfoWithUserId:[responseObject objectForKey:@"user_id"] orUserToken:[responseObject objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
                //判断是否为空，如果为空直接跳转
                if(user == NULL){//
                    HSLog(@"请求个人信息错误");
                }
                else{
                    HSLog(@"请求个人信息成功");
                    [self handleUserInfo:user];

                }
            }];
        }
        else{
            
            //登录失败，直接回调为空
            CallBack(nil);
            
            HSLog(@"%@",error);
            
        }
        
    }];
    
}

#pragma mark 执行用户登录操作，使用手机号密码
+ (void) doLoginWithUserPhone:(NSString*)userPhone andUserLoginPassword:userLoginPassword andRequestCB:(void(^)(NSString* userId))CallBack{
    
    //获取设备编号
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
    
    //构造数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         userPhone,@"user_phone",
                         userLoginPassword,@"user_login_pwd",
                         @"1",@"user_login_platform",
                         uuid,@"user_mac",
                         nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic hs_JsonString],@"requestData", nil];
    
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doLoginURL];
    
    [self getDataWithParameters:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(code){
            
            //只会返回user_id与user_token
            [[NSUserDefaults standardUserDefaults]
             setObject:[responseObject objectForKey:@"user_token"]
             forKey:@"user_token"];
            
            if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                
                [[NSUserDefaults standardUserDefaults]
                 setObject:[responseObject objectForKey:@"user_id"]
                 forKey:@"user_id"];
            }
            else{
                HSLog(@"没有返回id,id不是string, id = %@", [responseObject objectForKey:@"user_id"]);
            }

            //登录成功，跳转到主界面
            CallBack([responseObject objectForKey:@"user_id"]);
            
            //请求用户信息
            [self getUserInfoWithUserId:[responseObject objectForKey:@"user_id"] orUserToken:[responseObject objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
                //判断是否为空，如果为空直接跳转
                if(user == NULL){//
                    HSLog(@"请求个人信息错误");
                }
                else{
                    HSLog(@"请求个人信息成功");
                    [self handleUserInfo:user];

                }
            }];

        }
        else{
            
            //登录失败，直接回调为空
            CallBack(nil);
            
            HSLog(@"%@",error);
            
        }
        
    }];
    
}

#pragma mark 执行第三方登录
+ (void) doLoginWithThridSource:(NSString*)thirdSource
                      andOpenId:(NSString*)openId
                    andUserInfo:(id<ISSPlatformUser>)userInfo
                   andRequestCB:(void(^)(NSString* userId))CallBack{
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
    
    //首先判断用户是否第三方注册过，如果注册过则直接登录，否则注册
    //首先判断是否已经在我们平台，是的话直接登陆，否则注册后登陆
    NSDictionary *dicForThird = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 openId,@"uid",
                                 thirdSource,@"thirdSource",
                                 @"1",@"user_login_platform",
                                 uuid,@"user_mac",
                                 nil];
    
    NSDictionary *requestDataForThirdCheck = [[NSDictionary alloc] initWithObjectsAndKeys:[dicForThird hs_JsonString],@"requestData", nil];
    
    NSString *urlForThirdCheck = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doThirdIdCheckURL];
    
    [self getDataWithParameters:requestDataForThirdCheck andURL:urlForThirdCheck andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        
        if(!code){
            //如果获取数据出错，则直接回调错误
            CallBack(nil);
        }
        
        //登录成功，获取user_id
        NSDictionary* userInfoLiveForest = [responseObject objectForKey:@"userInfo"];
        
        if(![userInfoLiveForest isEqual:@"-10086"]){
            //用户已经注册,则直接填入user_token与user_id
            [[NSUserDefaults standardUserDefaults]
             setObject:[userInfoLiveForest objectForKey:@"user_token"]
             forKey:@"user_token"];
            
            [[NSUserDefaults standardUserDefaults]
             setObject:[userInfoLiveForest objectForKey:@"user_id"]
             forKey:@"user_id"];
            
            CallBack([userInfoLiveForest objectForKey:@"user_id"]);
            
            //请求用户信息
            [self getUserInfoWithUserId:[userInfoLiveForest objectForKey:@"user_id"] orUserToken:[userInfoLiveForest objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
                //判断是否为空，如果为空直接跳转
                if(user == NULL){//
                    HSLog(@"请求个人信息错误");
                }
                else{
                    HSLog(@"请求个人信息成功");
                    [self handleUserInfo:user];

                }
            }];

            return;
        
        }
        
        //如果没有注册，则直接进行注册
        
        NSString *nickname = [[NSString alloc] initWithFormat:@"%@",[userInfo nickname]];
        NSString *educations = [[NSString alloc] initWithFormat:@"%@",[userInfo educations]];
        NSString *gender = [[NSString alloc] initWithFormat:@"%ld",(long)[userInfo gender]];
        NSString *work = [[NSString alloc] initWithFormat:@"%@",[userInfo works]];
        
        //上传用户头像
        NSString *profileImage = [[NSString alloc] initWithFormat:@"%@",[userInfo profileImage]];
        
        [HSQiniuService uploadImageWithImageUrl:profileImage andRequestCB:^(BOOL code, id responseObject, NSString *error) {
            
            //实际上返回的是请求到的地址
            NSString* imgUrl = responseObject;
            
            //构造请求数据
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 openId,@"uid",
                                 thirdSource,@"thirdSource",
                                 gender,@"sex",
                                 nickname,@"nickname",
                                 imgUrl,@"profileImage",
                                 educations,@"educations",
                                 work,@"work",
                                 @"1",@"user_login_platform",
                                 uuid,@"user_mac",
                                 nil];
            
            //清除可能为空的数据
            NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
            for (id item in dic) {
                if ([[dic objectForKey:item] isEqualToString:@"(null)"]) {
                    [dicCopy setValue:@"" forKey:item];
                }else{
                    [dicCopy setValue:[dic objectForKey:item] forKey:item];
                }
            }
            
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dicCopy hs_JsonString],@"requestData", nil];
            
            //进行第三方注册
            NSString *urlForThirdLogin = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doThirdLoginURL];
            
            [self getDataWithParameters:requestData andURL:urlForThirdLogin andRequestCB:^(BOOL code, id responseObject, NSString *error) {
                //判断是否登录成功
                if(!code){
                    CallBack(nil);
                }
                
                //存储本地信息
                [[NSUserDefaults standardUserDefaults]
                 setObject:[responseObject objectForKey:@"user_token"]
                 forKey:@"user_token"];
                
                [[NSUserDefaults standardUserDefaults]
                 setObject:[responseObject objectForKey:@"user_id"]
                 forKey:@"user_id"];
                
                //融云的ID
                [[NSUserDefaults standardUserDefaults]
                 setObject:[responseObject objectForKey:@"rong_cloud_id"]
                 forKey:@"rong_cloud_id"];
                
                CallBack([responseObject objectForKey:@"user_id"]);
                
                //跳转到信息补全页面
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                HSRegisterViewController *HSRegisterVC = (HSRegisterViewController *)[sb instantiateViewControllerWithIdentifier:@"HSRegisterViewController"];
                [[UIApplication sharedApplication] keyWindow].rootViewController = HSRegisterVC;
                
                //请求用户信息
                [self getUserInfoWithUserId:[responseObject objectForKey:@"user_id"] orUserToken:[responseObject objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
                    //判断是否为空，如果为空直接跳转
                    if(user == NULL){//
                        HSLog(@"请求个人信息错误");
                    }
                    else{
                        HSLog(@"请求个人信息成功");
                        [self handleUserInfo:user];
                    }
                }];

            }];
            
        }];
        
    }];


}

#pragma mark - 获取用户信息成功后的处理
+ (void)handleUserInfo:(HSUserModel *)user {
    [HSUserModel setCurrentUser:user];
}


@end

//
//  HSHttpRequestTool.m
//  LiveForest
//
//  Created by 余超 on 15/12/1.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSHttpRequestTool.h"
//#import "AFNetworking.h"
#import "HSConstantURL.h"
#import "NSObject+HSJson.h"
#import "MBProgressHUD+MJ.h"
#import "HSLoginLogic.h"


static AFHTTPRequestOperationManager *manager;
//static NSString *urlPrefix = @"115.28.253.106:10086";   //线上请求测试前缀 16.8.19之前
//static NSString *urlPrefix = @"114.215.103.95:10086";   // 注意，HSConstantURL.h文件里还有一个要修改
//static NSString *urlPrefix = @"139.224.41.10:10086";   // 注意，HSConstantURL.h文件里还有一个要修改
static NSString *urlPrefix = @"10.25.28.106:10086";   // 注意，HSConstantURL.h文件里还有一个要修改
//139.224.41.10(公)
//10.25.28.106(内)

@implementation HSHttpRequestTool
#pragma mark - 测试

+ (AFHTTPRequestOperationManager *)manager {
    return manager;
}

#pragma mark - 初始化
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html", @"text/plain", @"text/json", @"application/json", nil];
    });
}

#pragma mark 新版本的方法
#pragma mark - Public

/**
 *  @param URLString  包含"api.liveforest.com", 方法会自动替换掉。
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    if (!URLString || !parameters) return failure(@"url或者parameters为空");
    
    URLString = [self convertURLString:URLString];
    parameters = @{@"requestData": [parameters mj_JSONString]};
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

// 自动构造请求参数，只包含 user_token
+ (void)GET:(NSString *)URLString success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    NSDictionary *para = @{@"user_token": [self userToken]};
    [self GET:URLString parameters:para success:success failure:failure];
}

// 自动解析 json。
+ (void)GET:(NSString *)URLString class:(Class)className key:(NSString *)key success:(void (^)(NSArray *objects))success failure:(void (^)(NSString *error))failure {
    NSDictionary *para = @{@"user_token": [self userToken]};
    [self GET:URLString parameters:para class:className key:key success:success failure:failure];
}

//自动解析 json
+ (void)GET:(NSString *)URLString parameters:(id)parameters class:(Class)className key:(NSString *)key success:(void (^)(NSArray *objects))success failure:(void (^)(NSString *error))failure {
    if (!URLString || !parameters) return failure(@"url或者parameters为空");
    
    URLString = [self convertURLString:URLString];
    parameters = @{@"requestData": [parameters mj_JSONString]};
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([self success:responseObject]) {
            NSArray *keyValues = [responseObject valueForKey:key];
            NSArray *objs = [className mj_objectArrayWithKeyValuesArray:keyValues];
            success(objs);
        } else {
            NSString *error = [responseObject objectForKey:@"desc"];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

/**
 *  @param URLString  包含"api.liveforest.com", 方法会自动替换掉。
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    if (!URLString || !parameters) return failure(@"url或者parameters为空");
    
    URLString = [self convertURLString:URLString];
    parameters = @{@"requestData": [parameters mj_JSONString]};

    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

/**
 *  @param URLString  包含"api.liveforest.com", 方法会自动替换掉。
 */
+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    if (!URLString || !parameters) return failure(@"url或者parameters为空");
    
    URLString = [self convertURLString:URLString];
    parameters = @{@"requestData": [parameters mj_JSONString]};

    [manager PUT:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

/**
 *  @param URLString  包含"api.liveforest.com", 方法会自动替换掉。
 */
+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    if (!URLString || !parameters) return failure(@"url或者parameters为空");
    
    URLString = [self convertURLString:URLString];
    parameters = @{@"requestData": [parameters mj_JSONString]};

    [manager DELETE:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

+ (NSString *)userToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [userDefaults objectForKey:@"user_token"];
    if (userToken == nil) {
        userToken = @"qnZ5awrOszYd1iFb3iLF9DJN2kCJ2B02FgzmX3a2F8gVM83D";
    }
//    HSLog(@"user_token %@", userToken);
    return userToken;
}

//http://doc.live-forest.com/share/#_26
+ (void)postShareLike:(NSString *)shareID success:(void (^)())success failure:(void (^)(NSString *error))failure {
    HSLog(@"点赞啦");
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/doShareLike";
    NSDictionary *para = @{@"user_token":[self userToken], @"share_id":shareID};
    
    [self POST:urlStr parameters:para success:^(id responseObject) {
        if (success) success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

#pragma mark - Private

/**
 *  替换掉"api.liveforest.com" 或者 "api.yueqiuba.com"
 */
+ (NSString *)convertURLString:(NSString *)origin {
    NSString *urlStr = [origin stringByReplacingOccurrencesOfString:@"api.liveforest.com" withString:urlPrefix];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"api.yueqiuba.com" withString:urlPrefix];
    
    return urlStr;
}

/**
 *  判断后台返回的数据是否正确
 */
+ (BOOL)success:(id)responseObject {
    int code = [[responseObject objectForKey:@"code"] intValue];
    return (code == 0)? YES: NO;
}

/**
 *  处理从后台返回的数据
 */
+ (void)handleResponseObject:(id)obj success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    if ([self success:obj]) {
        return success(obj);
    }
    
    NSString *error = [obj objectForKey:@"desc"];
    failure(error);
    
    if ([[obj objectForKey:@"subCode"] intValue] == 1) {
        ShowHud(@"鉴权失败，请重新登录", NO);
        //跳转到登陆界面，和注销处理一样
        [HSLoginLogic doLogOut];
    }
}

#pragma mark - 旧版本的方法
#pragma mark 通用请求接口 requestData包括 requestData
/**
 *  废弃。使用+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)getDataWithParameters:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,nil,@"请求参数缺失");
    }
    else{
        
        [manager GET:url
          parameters:requestData
             success:^(AFHTTPRequestOperation *operation, id responseObject){
                 
                 //如果请求成功，调用统一的请求方法
                 return [self responseDataHandler:operation
                                andResponseObject:responseObject
                                     andRequestCB:CallBack];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //fail
                 HSLog(@"%s 请求失败，%@", __func__, error);
                 return CallBack(false,nil,@"网络请求失败，请重试");
             }];
        
    }
    //    return ;
}

#pragma mark 通用请求接口 requestData包括 requestData
/**
 *  废弃。使用+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)postDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,nil,@"请求参数缺失");
    }
    else{
        
        [manager POST:url
           parameters:requestData
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  
                  //如果请求成功，调用统一的请求方法
                  return [self responseDataHandler:operation
                                 andResponseObject:responseObject
                                      andRequestCB:CallBack];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //fail
                  HSLog(@"请求失败，%@",error);
                  return CallBack(false,nil,@"网络请求失败，请重试");
              }];
        
    }
    return ;
}

#pragma mark 通用请求接口 requestData包括 requestData
/**
 *  废弃。使用+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)putDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,nil,@"请求参数缺失");
    }
    else{
        
        [manager PUT:url
          parameters:requestData
             success:^(AFHTTPRequestOperation *operation, id responseObject){
                 
                 //如果请求成功，调用统一的请求方法
                 return [self responseDataHandler:operation
                                andResponseObject:responseObject
                                     andRequestCB:CallBack];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //fail
                 HSLog(@"请求失败，%@",error);
                 return CallBack(false,nil,@"网络请求失败，请重试");
             }];
        
    }
    return ;
}

#pragma mark 通用请求接口 requestData包括 requestData
/**
 *  废弃。使用+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)deleteDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,nil,@"请求参数缺失");
    }
    else{
        
        [manager DELETE:url
             parameters:requestData
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                    //如果请求成功，调用统一的请求方法
                    return [self responseDataHandler:operation
                                   andResponseObject:responseObject
                                        andRequestCB:CallBack];
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //fail
                    HSLog(@"请求失败，%@",error);
                    return CallBack(false,nil,@"网络请求失败，请重试");
                }];
        
    }
    return ;
}

#pragma mark 通用响应处理
/**
 *  废弃。使用+ (void)handleResponseObject:(id)obj success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)responseDataHandler:(AFHTTPRequestOperation *)operation
          andResponseObject:(id)responseObject
               andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    
    if ([[responseObject objectForKey:@"code"] intValue]==0) {
        //需要数据处理
        return CallBack(true,responseObject,nil);
    }
    else{
        
        int subCode = [[responseObject objectForKey:@"subCode"] intValue];
        
        NSString *error = @"";
        
        switch (subCode) {
            case 0:
                error = @"请求参数缺失";
                break;
            case 1 :
                error = @"用户鉴权失败";
                ShowHud(@"鉴权失败，请重新登录", NO);
                //这个时候跳转到登陆界面，和注销处理一样
                [HSLoginLogic doLogOut];
                
                break;
            default:
                break;
        }
        
        HSLog(@"%@",[responseObject objectForKey:@"desc"]);
        
        //需要数据处理
        return CallBack(false,nil,[responseObject objectForKey:@"desc"]);
        
    }
    
    return;
}


@end

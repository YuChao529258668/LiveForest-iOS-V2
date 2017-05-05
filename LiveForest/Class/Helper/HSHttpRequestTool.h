//
//  HSHttpRequestTool.h
//  LiveForest
//
//  Created by 余超 on 15/12/1.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h" // 这里导入是为了让很多需要解析json的类导入。
#import "AFNetworking.h"

@interface HSHttpRequestTool : NSObject

+ (AFHTTPRequestOperationManager *)manager;

#pragma mark - 新版本的方法
/**
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

/**
 *  自动构造请求参数，只包含 user_token。
 *
 *  @param URLString 包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 */
+ (void)GET:(NSString *)URLString success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

/**
 *  自动构造请求参数(只包含 user_token)。自动解析json成对象。
 *
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 *  @param className  数据模型对象的class。
 *  @param key        用于提取后台返回的 json 数组。
 *  @param success    参数是一个对象数组，而不是json数组。
 */
+ (void)GET:(NSString *)URLString class:(Class)className key:(NSString *)key success:(void (^)(NSArray *objects))success failure:(void (^)(NSString *error))failure;

/**
 *  自动解析json成对象。
 *
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 *  @param className  数据模型对象的class。
 *  @param key        用于提取后台返回的 json 数组。
 *  @param success    参数是一个对象数组，而不是json数组。
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters class:(Class)className key:(NSString *)key success:(void (^)(NSArray *objects))success failure:(void (^)(NSString *error))failure;

/**
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 */
+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

/**
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

/**
 *  @param URLString  包含"api.liveforest.com"或者"api.yueqiuba.com", 方法会自动替换掉。
 */
+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

#pragma mark - Helper
+ (NSString *)userToken;

/**
 *  分享 承若点赞
 */
+ (void)postShareLike:(NSString *)shareID success:(void (^)())success failure:(void (^)(NSString *error))failure;

#pragma mark - 旧版本的方法
/**
 *  废弃。使用+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)getDataWithParameters:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack;

/**
 *  废弃。使用+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)postDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack;

/**
 *  废弃。使用+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)putDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack;

/**
 *  废弃。使用+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
 代替
 */
+ (void)deleteDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack;

@end

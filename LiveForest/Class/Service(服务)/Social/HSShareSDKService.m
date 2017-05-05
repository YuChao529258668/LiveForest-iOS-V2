//
//  HSShareSDKService.m
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareSDKService.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@implementation HSShareSDKService

+ (Boolean)initService{
    
    [ShareSDK registerApp:@"eff01756d90e"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2886581071"
                                appSecret:@"57016ce226c43fbcebd4db8cdbc896f5"
                              redirectUri:@"http://m.live-forest.com/index.php/Home/Weco/oauthCallback"
                              weiboSDKCls:[WeiboSDK class]];
    
    //    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
    //                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
    //                                redirectUri:@"http://www.sharesdk.cn"];
    //
    //    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    //    [ShareSDK connectQZoneWithAppKey:@"100371282"
    //                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    //
    //    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    //    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx20b6a34093f521ce"
                           appSecret:@"e7703ef18636376d70ce3035289ac511"
                           wechatCls:[WXApi class]];
    
    return YES;
    
}

@end

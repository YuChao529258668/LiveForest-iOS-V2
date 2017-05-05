//
//  UMengService.m
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSUMengService.h"
//蒲公英
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "UMessage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IOS_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@implementation HSUMengService

+(Boolean) initService{

    //初始化蒲公英
    //    一、关闭用户反馈功能(默认开启)：
    //
    //    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    //    二、自定义用户反馈激活方式(默认为摇一摇)：
    //
    //    // 设置用户反馈界面激活方式为三指拖动
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
    //
    //    // 设置用户反馈界面激活方式为摇一摇
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
    //    上述自定义必须在调用 [[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"] 前设置。
    
    //初始化蒲公英todo（随着提交，会变化）
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"0ce3ecdbe9f391472d202837aa57e56c"];
    
    [[PgyManager sharedPgyManager] setShakingThreshold:2.5];
    
    //自动检查更新
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    return YES;
}



@end

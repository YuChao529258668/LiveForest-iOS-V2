//
//  HSPersonalNotification.m
//  LiveForest
//
//  Created by 余超 on 16/3/21.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSPersonalNotification.h"
#import "HSHttpRequestTool.h"

@implementation HSPersonalNotification

- (void)setNotification_resource_name:(NSString *)notification_resource_name {
    _notification_resource_name = notification_resource_name;

//    判断通知类型，字符串转枚举。
    NSString *name = _notification_resource_name;
    NSUInteger type = 0;
    
    if ([name isEqualToString:@"share"]) {
        type = HSPersonalNotificationTypeShare;
    } else if ([name isEqualToString:@"yueban"]) {
        type = HSPersonalNotificationTypeYueBan;
    } else if ([name isEqualToString:@"goods"]) {
        type = HSPersonalNotificationTypeGoods;
    } else if ([name isEqualToString:@"challenge"]) {
        type = HSPersonalNotificationTypeChallenge;
    } else {
        type = HSPersonalNotificationTypeError;
        HSLog(@"%s,%@",__func__, @"notification_resource_name 有误");
    }
    
    _notificationType = type;
}

+ (void)getNotificationListSuccess:(void(^)(NSArray *notifications))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/notification", [HSHttpRequestTool userToken]];
    
//    以后可能要传参数
//    NSDictionary *para = @{@"aggregate": @(YES), @"where": @(NO)};
//    
//    [HSHttpRequestTool GET:urlstr parameters:para class:self.class key:@"notifications" success:^(NSArray *objects) {
//        success(objects);
//    } failure:^(NSString *error) {
//        failure(error);
//    }];
    
    [HSHttpRequestTool GET:urlstr class:self.class key:@"notifications" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end

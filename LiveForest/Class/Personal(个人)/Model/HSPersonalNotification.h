//
//  HSPersonalNotification.h
//  LiveForest
//
//  Created by 余超 on 16/3/21.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


/// 通知的类型，分享、约伴、挑战、商品
typedef NS_ENUM(NSUInteger, HSPersonalNotificationType) {
    HSPersonalNotificationTypeShare = 0,
    HSPersonalNotificationTypeYueBan = 1,
    HSPersonalNotificationTypeChallenge = 2,
    HSPersonalNotificationTypeGoods = 3,
    HSPersonalNotificationTypeError = -1
};

#import <Foundation/Foundation.h>

@interface HSPersonalNotification : NSObject

/// 通知的类型，类型是 HSPersonalNotificationType
@property (nonatomic, assign) NSUInteger notificationType;

/// share yueban goods challenge
@property (nonatomic, copy) NSString *notification_resource_name;

@property (nonatomic, assign) BOOL notification_is_read;

@property (nonatomic, copy) NSString *notification_title;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger notification_create_time;

@property (nonatomic, assign) NSInteger notification_id;

@property (nonatomic, copy) NSString *notification_content;

@property (nonatomic, copy) NSString *notification_resource_id;
@property (nonatomic, copy) NSString *notification_user_name;
@property (nonatomic, copy) NSString *notification_user_logo;

/**
 *  获取所有类型的通知列表
 */
+ (void)getNotificationListSuccess:(void(^)(NSArray *notifications))success failure:(void(^)(NSString *error))failure;

@end

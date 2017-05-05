//
//  HSOfficialDisplayPictureActivity.h
//  LiveForest
//
//  Created by 余超 on 16/2/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

//  获取所有官方主题晒图活动列表，http://doc.live-forest.com/share/#_27

#import <Foundation/Foundation.h>
@class HSRecommendShareModel;

/**
 *  官方主题晒图活动
 */
@interface HSOfficialDisplayPictureActivity : NSObject
//activity_id：活动ID
//activity_name:String 活动名字
//activity_summary:String 活动简介
//activity_img_path:Array 活动图片
//activity_user_num:String 总的参与人数
//attended_friend_num:String 我的好友的参与数
//activity_time:String 活动结束时间yyyy-MM-dd HH:mm:ss 如：2011-11-11 13:30:00
//create_time:String 活动创建时间

@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_summary;
@property (nonatomic, strong) NSArray *activity_img_path;
@property (nonatomic, copy) NSString *activity_user_num;
@property (nonatomic, copy) NSString *activity_time;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, strong) NSArray<__kindof HSRecommendShareModel *> *recommendShares;

+ (void)getActivityListSuccess:(void(^)(NSArray *activitys))success failure:(void(^)(NSString *error))failure;

+ (void)getShareListWithActivityID:(NSString *)activity_id PageNum:(int)num PageSize:(int)size Success:(void(^)(NSArray *shares))success failure:(void(^)(NSString *error))failure;

/// 用于演示
+ (NSMutableArray *)test;

@end

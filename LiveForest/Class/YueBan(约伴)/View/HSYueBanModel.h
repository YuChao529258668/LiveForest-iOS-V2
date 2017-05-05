//
//  HSYueBanModel.h
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

//http://doc.live-forest.com/activity/#_6

#import <Foundation/Foundation.h>

@interface HSYueBanModel : NSObject

@property (nonatomic, copy) NSString *yueban_id;  // String约伴纪录id
@property (nonatomic, copy) NSString *user_id;  // String约伴创建者id
@property (nonatomic, copy) NSString *yueban_voice_info;  // String约伴语音地址
@property (nonatomic, copy) NSString *yueban_user_city;  // String约伴创建者所在城市
@property (nonatomic, copy) NSString *create_time;  // String约伴创建时间
@property (nonatomic, copy) NSString *yueban_sport_id;  // String约伴运动类型
@property (nonatomic, copy) NSString *user_nickname;  // String约伴创建者昵称
@property (nonatomic, copy) NSString *user_logo_img_path;  // String约伴创建者头像
@property (nonatomic, copy) NSString *user_sex;  // String约伴创建者性别
@property (nonatomic, copy) NSString *user_introduction;  // String约伴创建者个人说明
@property (nonatomic, copy) NSString *user_birthday;  // String约伴创建者生日时间戳
@property (nonatomic, copy) NSString *estimated_time;  // String约伴创建者设置的约伴预计时间＋创建时间的结果的时间戳。用来算倒计时
@property (nonatomic, copy) NSString *user_sport;  // String约伴创建时的自定义运动

@property (nonatomic, copy) NSString *yueban_recommend_type;

/// '1':进行中,'0':已停止约伴
@property (nonatomic, strong) NSNumber *yueban_state;

/// 约伴文本信息
@property (nonatomic, copy) NSString *yueban_text_info;

@property (nonatomic, copy) NSString *yueban_voice_second;


/**
 *  获取我参与的约伴的历史记录的列表
 */
+ (void)getYueBansAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取我参加的和我创建的约伴历史，创建的只返回停止了的
 */
+ (void)getYueBansCreateSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

+ (NSMutableArray *)test;

@end

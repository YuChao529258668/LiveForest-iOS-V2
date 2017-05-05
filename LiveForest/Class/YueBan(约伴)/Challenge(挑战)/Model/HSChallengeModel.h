//
//  HSChallengeModel.h
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSUserModel;

@interface HSChallengeModel : NSObject

/// 这个属性是后台没有的，表示是否在别的界面被用户参与了，用于tableView删除对应的cell
@property (nonatomic, assign) BOOL isAttend;

/// 这个是时间戳转成的时间
@property (nonatomic, copy) NSString *deadlineDateString;

@property (nonatomic, copy) NSString *challenge_reward_text;

@property (nonatomic, copy) NSString *challenge_id;

/// 内容
@property (nonatomic, copy) NSString *challenge_content;

@property (nonatomic, copy) NSString *challenge_user_id_creator;

@property (nonatomic, strong) NSNumber *challenge_deadline;

/// 留言
@property (nonatomic, copy) NSString *challenge_text_info;

@property (nonatomic, strong) NSArray *challenge_user_id_invited;

@property (nonatomic, copy) NSString *challenge_reward_credit;

@property (nonatomic, copy) NSString *challenge_city_id;

/// 0 正在进行, 1 已结束
@property (nonatomic, strong) NSNumber *challenge_state;

@property (nonatomic, copy) NSString *challenge_create_time;

@property (nonatomic, strong) HSUserModel *user_creator;

/**
 *  获取我参加的，未完成的挑战
 */
+ (void)getChallengesAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取待参加的挑战
 */
+ (void)getChallengesNotAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取我发起的挑战
 */
+ (void)getChallengesCreateSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取我围观的挑战
 */
+ (void)getChallengesOnLookSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取某个分享关联的挑战
 */
+ (void)getChallengeWithShareID:(NSString *)shareID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  参加挑战
 */
- (void)attendChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure;

/**
 *  完成挑战
 */
- (void)finishChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure;

/**
 *  忽略挑战
 */
- (void)refuseChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure;

/**
 *  围观挑战，看好或者不看好
 *
 *  @param kanhao  0 - 不看好， 1 - 看好
 */
- (void)onlookChallengeWithKanHao:(NSString *)kanhao Success:(void (^)())success failure:(void (^)(NSString *error))failure;

+ (NSMutableArray *)test;

@end

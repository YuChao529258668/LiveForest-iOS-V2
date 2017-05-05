//
//  HSChallengeAttendModel.h
//  LiveForest
//
//  Created by 余超 on 16/3/30.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSRecommendShareModel.h"
#import "HSUserModel.h"

@interface HSChallengeAttendModel : NSObject

@property (nonatomic, strong) HSRecommendShareModel *share;

@property (nonatomic, assign) NSInteger challenge_attend_share_id;

@property (nonatomic, strong) HSUserModel *user_creator;

@property (nonatomic, assign) NSInteger challenge_attend_create_time;

@property (nonatomic, assign) NSInteger challenge_attend_challenge_id;

@property (nonatomic, copy) NSString *challenge_attend_user_id;

/// 0 - 未响应，仅用于@状态下 1 - 已参加但未完成 2 - 已完成 3 - 忽略 4 - 过时失败
@property (nonatomic, assign) NSInteger challenge_attend_state;

@property (nonatomic, assign) NSInteger challenge_attend_id;

@property (nonatomic, strong) NSArray *shares;
@property (nonatomic, strong) NSArray *user_creators;
@property (nonatomic, strong) NSArray *personsNotComplete;

/**
 * 获取 挑战的参与列表以及分享情况
 */
+ (void)getChallengeAttendsWithChallengeID:(NSString *)challengeID success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

@end



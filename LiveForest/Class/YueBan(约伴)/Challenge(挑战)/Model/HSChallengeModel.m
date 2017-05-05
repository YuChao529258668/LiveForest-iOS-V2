//
//  HSChallengeModel.m
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSChallengeModel.h"
#import "HSHttpRequestTool.h"

// 用于演示
#import "HSUserModel.h"

@implementation HSChallengeModel

- (void)setChallenge_deadline:(NSNumber *)challenge_deadline {
    _challenge_deadline = challenge_deadline;
    _deadlineDateString = [self dateStringWithDate:challenge_deadline];
}

// 11月11日 22:00
- (NSString *)dateStringWithDate:(NSNumber *)timeInterval {
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"MM月dd日 HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.doubleValue];
    return [dateF stringFromDate:date];
}

/// 获取我参加的，未完成的挑战，http://doc.live-forest.com/activity/#_18
+ (void)getChallengesAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge_attend/all/challenge", [HSHttpRequestTool userToken]];
    NSDictionary *requestData = @{@"challenge_attend_state": @1, @"resource_integration": @[@"user"]}; // 1表示正在參加的未結束的挑戰; user是为了获取创建者的信息。
    
    [HSHttpRequestTool GET:urlstr parameters:requestData class:self.class key:@"challenges" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 获取我发起的挑战
+ (void)getChallengesCreateSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge", [HSHttpRequestTool userToken]];
    
    [HSHttpRequestTool GET:urlstr class:self.class key:@"challenges" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 获取我围观的挑战列表
+ (void)getChallengesOnLookSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge_onlook/all/challenge", [HSHttpRequestTool userToken]];
    NSDictionary *requestData = @{@"resource_integration": @[@"user"]}; // user是为了获取创建者的信息。
    
    [HSHttpRequestTool GET:urlstr parameters:requestData class:self.class key:@"challenges" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 获取待参加的挑战列表，组团首页显示的挑战列表。
+ (void)getChallengesNotAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge_attend/all/challenge", [HSHttpRequestTool userToken]];
    NSDictionary *requestData = @{@"challenge_attend_state": @0, @"resource_integration": @[@"user"]}; // 0 表示获取所有@我的但是尚未参加的挑战，同时，也会自动推荐一些朋友创建的挑战; user是为了获取创建者的信息。
    
    [HSHttpRequestTool GET:urlstr parameters:requestData class:self.class key:@"challenges" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 获取某个分享关联的挑战
+ (void)getChallengeWithShareID:(NSString *)shareID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge_share", [HSHttpRequestTool userToken]];
    NSDictionary *requestData = @{@"share_id": shareID, @"resource_integration": @[@"user"]}; // user是为了获取创建者的信息。
    
    [HSHttpRequestTool GET:urlstr parameters:requestData class:self.class key:@"challenges" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

///参加挑战
- (void)attendChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure {
    NSString *user_token = [HSHttpRequestTool userToken];
    NSString *challengeID = self.challenge_id;
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge/%@/challenge_attend", user_token, challengeID];
    NSDictionary *requestData = @{@"challenge_attend_state": @1};
    
    [HSHttpRequestTool PUT:urlstr parameters:requestData success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

///完成挑战
- (void)finishChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure {
    NSString *user_token = [HSHttpRequestTool userToken];
    NSString *challengeID = self.challenge_id;
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge/%@/challenge_attend", user_token, challengeID];
    NSDictionary *requestData = @{@"challenge_attend_share_id": @2};
    
    [HSHttpRequestTool PUT:urlstr parameters:requestData success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 忽略挑战
- (void)refuseChallengeSuccess:(void (^)())success failure:(void (^)(NSString *error))failure {
    NSString *user_token = [HSHttpRequestTool userToken];
    NSString *challengeID = self.challenge_id;
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge/%@/challenge_attend", user_token, challengeID];
    NSDictionary *requestData = @{@"challenge_attend_state": @3};
    
    [HSHttpRequestTool PUT:urlstr parameters:requestData success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

- (void)onlookChallengeWithKanHao:(NSString *)kanhao Success:(void (^)())success failure:(void (^)(NSString *error))failure {
    NSString *user_token = [HSHttpRequestTool userToken];
    NSString *challengeID = self.challenge_id;
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge_attend/%@/challenge_onlook", user_token, challengeID];
    NSDictionary *requestData = @{@"challenge_onlook_kanhao": kanhao};
    
    [HSHttpRequestTool POST:urlstr parameters:requestData success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSUserModel *user = [HSUserModel new];
    user.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    user.user_nickname = @"小红";

    HSChallengeModel *m = [HSChallengeModel new];
    m.challenge_reward_text = @"我请吃饭";
    m.challenge_reward_credit = @"5";
    m.challenge_content = @"乒乓球";
    m.challenge_text_info = @"一起打球吧";
    m.challenge_user_id_invited = @[@"1", @"2"];
    m.challenge_deadline = @([[NSDate dateWithDaysFromNow:2] timeIntervalSince1970]);
    m.user_creator = user;
    
    HSChallengeModel *m2 = [HSChallengeModel new];
    m2.challenge_reward_text = @"带你吃好吃的";
    m2.challenge_reward_credit = @"10";
    m2.challenge_content = @"足球";
    m2.challenge_text_info = @"足球使人快乐";
    m2.challenge_user_id_invited = @[@"1", @"2", @"3"];
    m2.challenge_deadline = @([[NSDate dateTomorrow] timeIntervalSince1970]);
    m2.user_creator = user;
    
    [array addObject:m];
    [array addObject:m2];
  
    return array;
}

@end

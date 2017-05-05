//
//  HSRecommendShareModel.h
//  LiveForest
//
//  Created by 余超 on 15/12/4.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRecommendShareModel:NSObject

@property (nonatomic, strong) NSURL *avatarPath;
@property (nonatomic, strong) NSURL *firstContentImagePath;
@property (nonatomic, copy) NSString *likesCount;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *activityName;

//"share_in_challenge_id" = 400;
//"share_in_challenge_nums" = 2;
@property (nonatomic, copy) NSString *share_in_challenge_id;
//@property (nonatomic, copy) NSString *share_in_challenge_nums;
@property (nonatomic, strong) NSNumber *share_in_challenge_nums;

//@property (nonatomic, copy) NSString *share_desription;

@property (nonatomic, assign) NSInteger share_like_num;

//@property (nonatomic, assign) NSInteger share_comment_num;

@property (nonatomic, copy) NSString *delete_state;

@property (nonatomic, copy) NSString *share_category;

@property (nonatomic, copy) NSString *user_id;

//@property (nonatomic, assign) long long share_create_time;
@property (nonatomic, copy) NSString *share_create_time;

@property (nonatomic, copy) NSString *sport_ids;

@property (nonatomic, assign) NSInteger share_city;

//@property (nonatomic, assign) NSInteger share_id;
@property (nonatomic, copy) NSString *share_id;

//@property (nonatomic, copy) NSString *hasLiked;
@property (nonatomic) BOOL hasLiked;

@property (nonatomic, copy) NSString *share_img_path_with_lables;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *share_location;

@property (nonatomic, copy) NSString *user_logo_img_path;

@property (nonatomic, assign) NSInteger share_county;

@property (nonatomic, copy) NSString *share_paster_ids;

@property (nonatomic, assign) CGFloat share_lon;

@property (nonatomic, strong) NSArray<NSString *> *share_img_path;

@property (nonatomic, copy) NSString *share_description;

@property (nonatomic, copy) NSString *share_img_path_with_pasters;

@property (nonatomic, copy) NSString *comment_count;

@property (nonatomic, assign) CGFloat share_lat;

/**
 *  获取推荐的分享列表
 */
+ (void)getRecommendShareListWithPageNum:(int)num PageSize:(int)size Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 *  获取某个用户的分享列表
 *
 *  @param share_id 第几条开始
 *  @param number   数量
 */
+ (void)getUserShareListWithUserID:(NSString *)userID shareID:(int)share_id requestNum:(NSUInteger)number Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;


/// 根据挑战编号获取所有关联的分享
+ (void)getShareListWithUserID:(NSString *)userID challengeID:(NSString *)challengeID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/// 用于演示
+ (NSMutableArray *)test;

@end

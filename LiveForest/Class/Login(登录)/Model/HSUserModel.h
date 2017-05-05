//
//  UserModel.h
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface HSUserModel : RLMObject

//属性定义
//用户账户状态
//@property (nonatomic, copy) NSString *user_account_state;

//用户地址
//@property (nonatomic, copy) NSString *user_address;

//用户介绍
@property (nonatomic, copy) NSString *user_introduction;

//推荐的用户的编号
//@property (nonatomic, copy) NSString *recommend_user;

//用户编号
@property (nonatomic, copy) NSString *user_id;

//用户运动属性，用于映射
@property (nonatomic, copy) NSArray *user_sport_id;

//用户注册时间
//@property (nonatomic, copy) NSDate *user_register_time;

//用户个性签名
@property (nonatomic, copy) NSString *user_sign;

//@property (nonatomic, copy) NSString *user_age_group_id;

//用户性别
@property (nonatomic, copy) NSString *user_sex;

//@property (nonatomic, copy) NSString *user_sport_tag;

/// 时间戳
@property (nonatomic, copy) NSString *user_birthday;

//用户城市编号，江苏南京
@property (nonatomic, copy, readonly) NSNumber<RLMInt> *user_city;
/// 用户城市名字，江苏南京
@property (nonatomic, strong) NSString *user_city_string;

//用户区域编号，栖霞区
@property (nonatomic, copy) NSNumber<RLMInt> *user_county;
///用户区域编号，栖霞区
@property (nonatomic, copy) NSString *user_county_string;

//@property (nonatomic, copy) NSNumber<RLMInt> *reported_times;

//@property (nonatomic, copy) NSString *user_work;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *user_logo_img_path;

//@property (nonatomic, copy) NSString *user_wechat_info;

//用户微博信息
//@property (nonatomic, copy) NSString *user_weco_info;

//@property (nonatomic, copy) NSString *user_education;

//@property (nonatomic, copy) NSString *user_age;//根据生日

//用户个人隐私设置
//@property (nonatomic, copy) NSString *user_privacy;

//用户二维码
//@property (nonatomic, copy) NSString *user_qr_code;
/// 用户积分
@property (nonatomic, copy) NSNumber<RLMInt> *user_credit_num;
@property (nonatomic, copy) NSNumber<RLMInt> *user_fans_num;
@property (nonatomic, copy) NSNumber<RLMInt> *user_following_num;
@property (nonatomic, copy, readonly) NSNumber<RLMInt> *user_relationship;

@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, copy) NSString *user_wechat_id;
@property (nonatomic, copy) NSString *user_weco_id;
@property (nonatomic, copy) NSString *wechat_logo_img_path;
@property (nonatomic, copy) NSString *wechat_nickname;
@property (nonatomic, copy) NSString *weco_logo_img_path;
@property (nonatomic, copy) NSString *weco_nickname;
@property (nonatomic, copy) NSString *rong_cloud_id;

/// 约伴数量
@property (nonatomic, strong) NSNumber<RLMInt> *yuebanCount;
/// 挑战数量
@property (nonatomic, strong) NSNumber<RLMInt> *challengeCount;
/// 订单数量
@property (nonatomic, strong) NSNumber<RLMInt> *orderCount;

/// 0:已关注,1:互相关注
@property (nonatomic, copy) NSString *isFans;

/// 保存修改后的头像，在个人界面修改过头像才会有值，初始值为nil
@property (nonatomic, strong) NSData *modifyAvatarData;
// RLMObject不支持UIimage。。。改用上面的属性
//@property (nonatomic, strong) UIImage *modifyAvatar;

+(void) setUserToken:(NSString*)usertoken;
+(void) setUserID:(NSString*)setUserID;
+(NSString*) getUserToken;
+ (NSString *)userID;
+(void) removeUserToken;

//@property (nonatomic, strong) HSUserModel *currentUser;
+ (instancetype)currentUser;
+ (void)setCurrentUser:(HSUserModel *)user;
+ (void)getUserInfoWithUserID:(NSString *)userID success:(void(^)(HSUserModel *userInfo))success failure:(void(^)(NSString *error))failure;

+ (void)updateAvatar:(UIImage *)avatar imageName:(NSString *)name success:(void(^)(NSString *imagePath))success failure:(void(^)(NSString *error))failure;
+ (void)updateNickName:(NSString *)name success:(void(^)())success failure:(void(^)(NSString *error))failure;
/// 江苏南京
+ (void)updateCity:(NSString *)city WithProvince:(NSString *)province success:(void(^)())success failure:(void(^)(NSString *error))failure;
/// 栖霞区
+ (void)updateCounty:(NSString *)county WithProvince:(NSString *)province city:(NSString *)city success:(void(^)())success failure:(void(^)(NSString *error))failure;
/// // birthday传的字符串 "user_birthday":"2011-11-11"
+ (void)updateBirthday:(NSString *)birthday success:(void(^)())success failure:(void(^)(NSString *error))failure;
+ (void)updateSign:(NSString *)sign success:(void(^)())success failure:(void(^)(NSString *error))failure;
+ (void)updateIntroduction:(NSString *)Introduction success:(void(^)())success failure:(void(^)(NSString *error))failure;

/// 关注某人
+ (void)followPerson:(NSString *)userID success:(void(^)())success failure:(void(^)(NSString *error))failure ;
/// 取消关注某人
+ (void)followCancelPerson:(NSString *)userID success:(void(^)())success failure:(void(^)(NSString *error))failure;
/// 获取我关注的人列表
+ (void)getFollowingListWithUserID:(NSString *)userID success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/// 获取用户的约伴、挑战、订单数量，保存在user对象里
+ (void)getUserStatisticsWithUserID:(NSString *)userID success:(void(^)())success failure:(void(^)(NSString *error))failure;


#pragma mark - 保存最近的登录手机号和密码
+ (void)saveLastPhoneNumber:(NSString *)phone password:(NSString *)password;
+ (NSString *)lastPhoneNumber;
+ (NSString *)lastPassword;

+ (HSUserModel *)test;

@end

RLM_ARRAY_TYPE(HSUserModel)





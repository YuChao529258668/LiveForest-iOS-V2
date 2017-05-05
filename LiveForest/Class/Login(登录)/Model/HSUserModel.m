//
//  UserModel.m
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSUserModel.h"
#import "HSDataFormatHandle.h"
#import "HSHttpRequestTool.h"
#import "HSQiniuService.h"

static HSUserModel *currentUser;
NSString *const HSLastPhoneNumber = @"HSLastPhoneNumber";
NSString *const HSLastPassword = @"HSLastPassword";

@implementation HSUserModel

#pragma mark 忽略复杂类型的属性
+ (NSArray *)ignoredProperties {
    return @[@"user_sport_id"];
}

#pragma mark 索引属性
+ (NSArray *)indexedProperties {
    return @[@"user_id"];
}

#pragma mark 主键属性
+ (NSString *)primaryKey {
    return @"user_id";
}


#pragma mark - Setter

/*
 设置用户性别
 */
+ (void) saveSex:(id)sex{
    
    NSString *user_sex = [HSDataFormatHandle handleNumber:sex];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //性别
    [userDefaults setObject:user_sex forKey:@"user_sex"];
    
}
/*
 设置用户昵称
 */
- (void) setName:(id)name{
    
    NSString *nickName = [HSDataFormatHandle handleNumber:name];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //昵称
    NSString *user_nickname = [[NSString alloc] initWithString:
                               [nickName isEqualToString:
                                @"-10086"]?@"" : nickName];
    [userDefaults setObject:user_nickname forKey:@"user_nickname"];
    
}


/**
 *  持久化user_token
 *
 *  @param usertoken
 */
+(void) setUserToken:(NSString*)usertoken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:usertoken forKey:@"user_token"];
    [userDefaults synchronize];
}
+(void) setUserID:(NSString*)setUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:setUserID forKey:@"user_id"];
    [userDefaults synchronize];
}
#pragma mark -获取持久化的user_token
/**
 *  获取持久化的user_token
 *
 *  @return 返回user_token
 */
+(NSString*) getUserToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"user_token"];
}

+ (NSString *)userID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"user_id"];
    if (userID == nil) {
        userID = @"143218500373424379";
    }
    HSLog(@"user_id = %@", userID);
    return userID;
}

#pragma mark -删除user_token
/**
 *  删除user_token
 */
+(void) removeUserToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_token"];
    [userDefaults synchronize];
}

//+ set

#pragma mark - 新版本

+ (instancetype)currentUser {
    return currentUser;
}

+ (void)setCurrentUser:(HSUserModel *)user {
    currentUser = user;
}

+ (void)getUserInfoWithUserID:(NSString *)userID success:(void(^)(HSUserModel *userInfo))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/getPersonInfo";
    NSString *user_token = [self getUserToken];
    NSDictionary *para = @{@"user_token": user_token, @"user_id": userID}; 
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *userInfo = [responseObject valueForKey:@"userInfo"];
        HSUserModel *user = [HSUserModel mj_objectWithKeyValues:userInfo];
        success(user);
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (NSString *)user_birthday {
//    NSDateFormatter *df = [NSDateFormatter new];
//    df.dateFormat = @"yyyy-MM-dd";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_user_birthday.doubleValue];
////    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970];
//    return [df stringFromDate:date];
    
    return [HSDataFormatHandle dayString_yyyy_MM_dd:_user_birthday.doubleValue];
}

- (void)setUser_city:(NSNumber<RLMInt> *)user_city {
    _user_city = user_city;
    
    self.user_city_string = [HSDataFormatHandle areaFormatHandleWithStringID:[NSString stringWithFormat:@"%@", _user_city]];
}

- (void)setUser_county:(NSNumber<RLMInt> *)user_county {
    _user_county = user_county;
    self.user_county_string = [HSDataFormatHandle areaFormatHandleWithStringID:[NSString stringWithFormat:@"%@", _user_county]];
}

+ (void)updateAvatar:(UIImage *)avatar imageName:(NSString *)name success:(void(^)(NSString *imagePath))success failure:(void(^)(NSString *error))failure {
    HSLog(@"%s,%@",__func__, @"开始上传图片到七牛");

//    先上传到七牛获取url
    [HSQiniuService uploadImage:avatar fileName:name requestCB:^(BOOL code, id responseObject, NSString *error) {
        if (responseObject) {
            // 返回的好像是字符串
            HSLog(@"%s,%@",__func__, @"上传七牛成功");
            
//            然后开始更新到后台
            NSString *imagePathStr = responseObject;
            NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonLogo";
            NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_logo_img_path": imagePathStr};
            
            [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
                currentUser.user_logo_img_path = imagePathStr;
                currentUser.weco_logo_img_path = imagePathStr;
                currentUser.wechat_logo_img_path = imagePathStr;
                
                success(imagePathStr);
            } failure:^(NSString *error) {
                failure(error);
            }];
        } else {
            failure(error);
            HSLog(@"%s,%@",__func__, @"上传七牛失败");
        }
    }];
}

+ (void)updateNickName:(NSString *)name success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonNickname";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_nickname": name};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        currentUser.user_nickname = name;
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)updateCity:(NSString *)city WithProvince:(NSString *)province success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *cityNumber = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:nil];
    
    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonCity";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_city": cityNumber};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        HSUserModel *user = [HSUserModel currentUser];
        user.user_city = @(cityNumber.intValue);
        user.user_county = @(-10086);
        user.user_city_string = city;
        user.user_county_string = nil;  // 修改城市需要修改地区吗？

        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)updateCounty:(NSString *)county WithProvince:(NSString *)province city:(NSString *)city success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *cityNumber = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:nil];
    NSString *countyNumber = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:county];

    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonCounty";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_county": countyNumber};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        HSUserModel *user = [HSUserModel currentUser];
        user.user_city = @(cityNumber.intValue);
        user.user_county = @(countyNumber.intValue);
        user.user_city_string = city;
        user.user_county_string = county;
        
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

// birthday传的字符串 "user_birthday":"2011-11-11"
+ (void)updateBirthday:(NSString *)birthday success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonBirthday";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_birthday": birthday};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [df dateFromString:birthday];
        // 用户的生日是时间戳
        currentUser.user_birthday = [NSString stringWithFormat:@"%lf",date.timeIntervalSince1970];
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)updateSign:(NSString *)sign success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonSign";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_sign": sign};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        currentUser.user_sign = sign;
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)updateIntroduction:(NSString *)Introduction success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/updatePersonIntroduction";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_introduction": Introduction};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        currentUser.user_introduction = Introduction;
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)getUserStatisticsWithUserID:(NSString *)userID success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/User/Person/getPersonStatistics";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_id": userID};
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        HSUserModel *user = [HSUserModel currentUser];
        user.yuebanCount = [responseObject valueForKey:@"yueban"];
        user.challengeCount = [responseObject valueForKey:@"challenge"];
        user.orderCount = [responseObject valueForKey:@"order"];
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)followPerson:(NSString *)userID  success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/Social/Following/doFollowingAttention";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_following_id": userID};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)followCancelPerson:(NSString *)userID success:(void(^)())success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/Social/Following/doFollowingCancel";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_following_id": userID};
    
    [HSHttpRequestTool POST:urlstr parameters:para success:^(id responseObject) {
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)getFollowingListWithUserID:(NSString *)userID success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/Social/Following/getFollowingList";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"user_id": userID};

    [HSHttpRequestTool GET:urlstr parameters:para class:self.class key:@"followingList" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

#pragma mark - Set
- (void)setUser_sign:(NSString *)user_sign {
    if (user_sign == nil) {
        _user_sign = @"";
    }
    _user_sign = user_sign;
}

#pragma mark - 保存最近登录的手机号和密码

+ (void)saveLastPhoneNumber:(NSString *)phone password:(NSString *)password {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:phone forKey:HSLastPhoneNumber];
    [ud setObject:password forKey:HSLastPassword];
    [ud synchronize];
}

+ (NSString *)lastPhoneNumber {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:HSLastPhoneNumber];
}

+ (NSString *)lastPassword {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:HSLastPassword];
}

/// 用于演示
+ (HSUserModel *)test {
    HSUserModel *u = [HSUserModel new];
    u.user_sign = @"我的签名";
    u.user_nickname = @"小红";
    u.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    u.user_fans_num = @2;
    u.user_following_num = @3;
    u.user_credit_num = @100;
    u.yuebanCount = @4;
    u.challengeCount = @5;
    u.orderCount = @6;
    u.user_county_string = @"广州";
    return u;
}


@end

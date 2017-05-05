//
//  HSChallengeAttendModel.m
//  LiveForest
//
//  Created by 余超 on 16/3/30.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSChallengeAttendModel.h"
#import "HSHttpRequestTool.h"

@implementation HSChallengeAttendModel

//{
//    "challenge_attends" =     (
//                               {
//                                   "challenge_attend_challenge_id" = 402;
//                                   "challenge_attend_create_time" = 1458199047;
//                                   "challenge_attend_id" = 257;
//                                   "challenge_attend_share_id" = 12;
//                                   "challenge_attend_state" = 0;
//                                   "challenge_attend_user_id" = 143218500373424379;
//                                   share =             {
//                                       "$ref" = "$.challenge_attends[0].shares[0]";
//                                   };
//                                   shares =             (
//                                                         {
//                                                             "delete_state" = 1;
//                                                             hasLiked = 0;
//                                                             "share_category" = 0;
//                                                             "share_city" = 0;
//                                                             "share_comment_num" = 0;
//                                                             "share_county" = 0;
//                                                             "share_create_time" = 1432630090000;
//                                                             "share_description" = "\U722c\U6811\U4e5f\U662f\U4e00\U9879\U7279\U6b8a\U6280\U80fd";
//                                                             "share_id" = 12;
//                                                             "share_img_path" =                     (
//                                                                                                     "http://7xiokh.com1.z0.glb.clouddn.com/IMG_2174.JPG"
//                                                                                                     );
//                                                             "share_lat" = 0;
//                                                             "share_like_num" = 0;
//                                                             "share_lon" = 0;
//                                                             "user_id" = 143222481224591618;
//                                                             "user_logo_img_path" = "http://7sbpfh.com1.z0.glb.clouddn.com/@/business/imageTestByHot/2015-06-13 18:30:35/91303020/1434954854798";
//                                                             "user_nickname" = "M-wpm-M ";
//                                                         }
//                                                         );
//                                   "user_creator" =             {
//                                       "rong_cloud_id" = "KdYerbdJU8JqDs6NGg6FItGtQfYVwcTOdszM2MN6Wo1XWF0zWd0yAbyH7guKmQc9x84wTY/eX4cgs7cFvD8brh0L1EH2IM8xw1ArE0Xak0E=";
//                                       "user_birthday" = 1320940800000;
//                                       "user_city" = 1;
//                                       "user_credit_num" = 31;
//                                       "user_fans_num" = 2;
//                                       "user_following_num" = 0;
//                                       "user_id" = 143218500373424379;
//                                       "user_logo_img_path" = "http://7sbpfh.com1.z0.glb.clouddn.com/@/business/0/2015-06-13 18:30:35/3902/1435916061003";
//                                       "user_nickname" = "LF\U4e3b\U9875\U541b";
//                                       "user_phone" = 15851808077;
//                                       "user_sex" = 1;
//                                       "user_sport_id" =                 (
//                                                                          1,
//                                                                          2
//                                                                          );
//                                   };
//                                   "user_creators" =             (
//                                                                  {
//                                                                      "$ref" = "$.challenge_attends[0].user_creator";
//                                                                  }
//                                                                  );
//                               },
//                               {
//                                   "challenge_attend_challenge_id" = 402;
//                                   "challenge_attend_create_time" = 1450174310;
//                                   "challenge_attend_id" = 258;
//                                   "challenge_attend_share_id" = "-1";
//                                   "challenge_attend_state" = 0;
//                                   "challenge_attend_user_id" = 143230083893647623;
//                                   shares =             (
//                                                         "<null>"
//                                                         );
//                                   "user_creator" =             {
//                                       "rong_cloud_id" = "sVUXuYxoxCjSW873RROXJNGtQfYVwcTOdszM2MN6Wo3B3xKJpkDHJ5r/tCslJzwex84wTY/eX4dkGtD0ftYSvgPSkOQKeHR8POZo3n9dMSg=";
//                                       "user_credit_num" = 5;
//                                       "user_fans_num" = 1;
//                                       "user_following_num" = 0;
//                                       "user_id" = 143230083893647623;
//                                       "user_logo_img_path" = "http://wx.qlogo.cn/mmopen/ofvnGicEPbfTGDfFyLJw0HsSA3hGSRQyuVuHEFgcXibSdnNvhlJJ3zFg4N741lxMGUAAtK4hndevYCHfRUlGolWw/0";
//                                       "user_nickname" = "Shmily K";
//                                       "user_phone" = "";
//                                       "user_sex" = 1;
//                                       "user_sport_id" =                 (
//                                       );
//                                       "user_wechat_id" = o3LILj6TF1gNQDFfgU407LNvhu1w;
//                                       "wechat_logo_img_path" = "http://wx.qlogo.cn/mmopen/ofvnGicEPbfTGDfFyLJw0HsSA3hGSRQyuVuHEFgcXibSdnNvhlJJ3zFg4N741lxMGUAAtK4hndevYCHfRUlGolWw/0";
//                                       "wechat_nickname" = "Shmily K";
//                                   };
//                                   "user_creators" =             (
//                                                                  {
//                                                                      "$ref" = "$.challenge_attends[1].user_creator";
//                                                                  }
//                                                                  );
//                               }
//                               );
//    code = 0;
//}

+ (void)getChallengeAttendsWithChallengeID:(NSString *)challengeID success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge/%@/challenge_attend", [HSHttpRequestTool userToken], challengeID];
    NSDictionary *requestData = @{@"resource_integration": @[@"share", @"user"]};
    
    [HSHttpRequestTool GET:urlstr parameters:requestData class:self.class key:@"challenge_attends" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];

}


+ (NSDictionary *)objectClassInArray{
    return @{@"user_creators" : [HSUserModel class], @"shares" : [HSRecommendShareModel class]};
}

- (void)setShares:(NSArray *)shares {
    _shares = shares;
    
    self.share = shares.firstObject;
}

- (void)setUser_creators:(NSArray *)user_creators {
    _user_creators = user_creators;
    self.user_creator = user_creators.firstObject;
}

- (HSRecommendShareModel *)share {
    return self.shares.firstObject;
}

- (HSUserModel *)user_creator {
    return self.user_creators.firstObject;
}

@end



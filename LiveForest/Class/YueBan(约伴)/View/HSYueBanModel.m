//
//  HSYueBanModel.m
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSYueBanModel.h"
#import "HSHttpRequestTool.h"

@implementation HSYueBanModel

/// 获取我参与的约伴的历史记录的列表
+ (void)getYueBansAttendSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/Social/YueBan/getMyAttendYueBanList";
    
    [HSHttpRequestTool GET:urlstr class:self.class key:@"yuebanList" success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 获取我参加的和我创建的约伴历史，创建的只返回停止了的
+ (void)getYueBansCreateSuccess:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlstr = @"http://api.liveforest.com/Social/YueBan/getMyYueBanRecordList";
    
    [HSHttpRequestTool GET:urlstr class:self.class key:@"yuebanList" success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (NSMutableArray *)test {

    NSMutableArray *array = [NSMutableArray array];
    
    HSYueBanModel *model = [HSYueBanModel new];
    model.yueban_sport_id = @"13";
    model.user_nickname = @"昵称";
    model.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    model.user_sex = @"男";
    model.user_introduction = @"user_introduction";
    model.yueban_text_info = @"yueban_text_info";
    
    [array addObject:model];
    [array addObject:model];
    
    return array;
}

@end

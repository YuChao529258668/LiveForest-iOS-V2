//
//  HSOfficialDisplayPictureActivity.m
//  LiveForest
//
//  Created by 余超 on 16/2/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


#import "HSOfficialDisplayPictureActivity.h"
#import "HSHttpRequestTool.h"
#import "HSRecommendShareModel.h"

@implementation HSOfficialDisplayPictureActivity

- (BOOL)isEqual:(id)object {
    HSOfficialDisplayPictureActivity *model = (HSOfficialDisplayPictureActivity *)object;
    if ([self.activity_id isEqualToString:model.activity_id]) {
        return YES;
    }
    return NO;
}

+ (void)getActivityListSuccess:(void(^)(NSArray *))success failure:(void(^)(NSString *))failure {
    //  获取所有官方主题晒图活动列表，http://doc.live-forest.com/share/#_27
    NSString *urlStr = @"http://api.yueqiuba.com/Social/Activity/getDisplayPicActivityList";
    
    [HSHttpRequestTool GET:urlStr success:^(id responseObject) {
        NSArray *displayPicActivityList = [responseObject objectForKey:@"displayPicActivityList"];
        NSArray *activitys = [self mj_objectArrayWithKeyValuesArray:displayPicActivityList];
        success(activitys);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

// 获取活动的分享列表
+ (void)getShareListWithActivityID:(NSString *)activity_id PageNum:(int)num PageSize:(int)size Success:(void(^)(NSArray *))success failure:(void(^)(NSString *))failure {
    NSString *urlstr = @"http://api.yueqiuba.com/Social/Activity/getDisplayPicActivityInfo";
    NSString *user_token = [HSHttpRequestTool userToken];
    NSDictionary *para = @{@"user_token" : user_token,
                           @"activity_id": activity_id,
                           @"pageNum" : @(num),
                           @"pageSize" : @(size)};
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *activityInfo = [responseObject valueForKey:@"activityInfo"];
        NSArray *shareList = [HSRecommendShareModel mj_objectArrayWithKeyValuesArray:[activityInfo valueForKey:@"shareList"]];
        success(shareList);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSOfficialDisplayPictureActivity *a = [HSOfficialDisplayPictureActivity new];
    a.activity_name = @"瘦成一道闪电";
    a.activity_summary = @"一起来减脂";
    a.activity_img_path = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493725893388&di=bac27eccd72c1e717700daa8a0038bcd&imgtype=0&src=http%3A%2F%2Fimage15.poco.cn%2Fmypoco%2Fmyphoto%2F20130911%2F18%2F1741652072013091118115104.jpg"];
    a.activity_user_num = @"3";
    a.activity_time = @"2018-1-1";
    a.create_time = @"2017-1-1";
    
    HSOfficialDisplayPictureActivity *a2 = [HSOfficialDisplayPictureActivity new];
    a2.activity_name = @"征服珠穆朗玛峰";
    a2.activity_summary = @"巴拉巴拉小魔仙~";
    a2.activity_img_path = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493720129500&di=cad74c9655f4781c0f779d6abdf7ecba&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fd52a2834349b033bca660d4215ce36d3d439bdb8.jpg"];
    a2.activity_user_num = @"32";
    a2.activity_time = @"2019-1-1";
    a2.create_time = @"2017-1-1";
    
    [array addObject:a];
    [array addObject:a2];

    return array;
}


@end

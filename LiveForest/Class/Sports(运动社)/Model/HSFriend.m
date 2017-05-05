//
//  HSFriend.m
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSFriend.h"
#import "HSHttpRequestTool.h"

@implementation HSFriend

- (BOOL)isEqual:(id)object {
    HSFriend *model = (HSFriend *)object;
    if ([self.user_id isEqualToString:model.user_id]) {
        return YES;
    }
    return NO;
}

+ (void)getFriendListSuccess:(void(^)(NSArray *))success failure:(void(^)(NSString *))failure {
    NSString *urlStr = @"http://api.liveforest.com/Social/Following/getFriendsList";
    
//    [HSHttpRequestTool GET:urlStr success:^(id responseObject) {
//        NSArray *modes = [responseObject objectForKey:@"friendsList"];
//        NSArray *activitys = [self mj_objectArrayWithKeyValuesArray:modes];
//        success(activitys);
//    } failure:^(NSString *error) {
//        failure(error);
//    }];
    
    [HSHttpRequestTool GET:urlStr class:self.class key:@"friendsList" success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end

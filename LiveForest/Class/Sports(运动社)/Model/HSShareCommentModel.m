//
//  HSShareCommentModel.m
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareCommentModel.h"
#import "HSHttpRequestTool.h"

//http://doc.live-forest.com/share/#_24

@implementation HSShareCommentModel

+ (void)getCommentListWithShareID:(NSString *)shareID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/getShareComment";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken], @"share_id": shareID};
    
    [HSHttpRequestTool GET:urlStr parameters:para class:self.class key:@"shareComment" success:^(NSArray *objects) {
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end

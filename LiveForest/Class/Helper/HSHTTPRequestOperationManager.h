//
//  HSHTTPRequestOperationManager.h
//  LiveForest
//
//  Created by 余超 on 16/3/3.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


@interface HSHTTPRequestOperationManager : AFHTTPRequestOperationManager

- (void)get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

@end

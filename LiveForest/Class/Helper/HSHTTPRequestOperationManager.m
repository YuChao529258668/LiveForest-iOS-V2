//
//  HSHTTPRequestOperationManager.m
//  LiveForest
//
//  Created by 余超 on 16/3/3.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSHTTPRequestOperationManager.h"

@implementation HSHTTPRequestOperationManager

#pragma mark - Overrite

+ (instancetype)manager {
    HSHTTPRequestOperationManager *manager = [self manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html", @"text/plain", @"text/json", @"application/json", nil];
    return manager;
}

#pragma mark - Public

- (void)get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self handleSuccess:success failure:failure responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self handleFailure:failure error:error];
    }];
}

#pragma mark - Private

- (BOOL)success:(id)responseObject {
    int code = [[responseObject objectForKey:@"code"] intValue];
    return (code == 0)? YES: NO;
}

- (void)handleSuccess:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure responseObject:(id)obj {
    if ([self success:obj]) {
        success(obj);
    } else {
        failure([obj objectForKey:@"desc"]);
    }
}

- (void)handleFailure:(void (^)(NSString *error))failure error:(NSError *)error {
    failure(error.localizedDescription);
}

@end
